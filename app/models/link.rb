require 'title_fetcher'

class Link < ActiveRecord::Base
  validates :url, presence: true, allow_blank: false
  validates :url, uniqueness: { scope: %i(subcategory_id) }

  validates :subcategory_id, presence: true

  validate :validate_url_format

  belongs_to :subcategory

  has_one :promo_announcement, dependent: :destroy
  accepts_nested_attributes_for :promo_announcement, reject_if: ->(attributes) { !attributes[:is_visible] && attributes[:message].empty? }

  before_validation :fix_url

  after_save :async_fetch_title_and_save

  scope :no_title, -> { where("title is null or title = ''") }

  default_scope -> { order(score: :desc) }

  acts_as_taggable
  acts_as_votable

  def category
    subcategory.category
  end

  def hostname
    URI(url).hostname
  end

  def fix_url
    self.url = self.class.fix_url url
  end

  def validate_url_format
    unless url =~ /^#{URI.regexp(['http', 'https'])}$/
      errors.add(:url_format, 'is invalid')
    end
  end

  def async_fetch_title_and_save
    return if self.title

    TitleFetcherWorker.perform_async(self.id)
  end

  def to_s
    return title unless title.nil? || title.empty?
    return hostname
  end

  def truncated_title how_much
    return to_s unless how_much
    to_s.truncate how_much
  end

  def self.fetch_missing_titles
    ids_to_fetch = no_title.pluck(:id)
    ids_to_fetch.each { |id| TitleFetcherWorker.perform_async(id) }
    return ids_to_fetch.count
  end

  def upvote_by user
    vote_up user
    update_score
  end

  def downvote_by user
    vote_down user
    update_score
  end

  def update_score
    self.score = weighted_score
    save
  end

  def score
    value = read_attribute(:score)
    return value if value
    update_score
    read_attribute(:score)
  end

  def self.fix_url url
    if url =~ /:\/\// # no protocol
      return url
    else
      if url =~ /\A[\w\.]+\.[\w]+[\w\/\?\&\=\%]+\Z/
        # ^ seems like a valid url with protocol missing
        return 'http://' + url # add protocol
      else
        url
      end
    end
  end
end
