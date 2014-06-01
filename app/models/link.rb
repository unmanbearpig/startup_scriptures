require 'title_fetcher'

class Link < ActiveRecord::Base
  validates :url, presence: true, allow_blank: false
  validates :subcategory_id, presence: true

  validate :validate_url_format

  belongs_to :subcategory

  has_one :promo_announcement
  accepts_nested_attributes_for :promo_announcement, reject_if: ->(attributes) { !attributes[:is_visible] && attributes[:message].empty? }

  before_validation :fix_url

  after_save :async_fetch_title_and_save

  scope :no_title, -> { where("title is null or title = ''") }

  acts_as_taggable
  acts_as_votable

  def category
    subcategory.category
  end

  def hostname
    URI(url).hostname
  end

  def fix_url
    unless url =~ /:\/\// # no protocol
      if url =~ /\A[\w\.]+\.[\w]+[\w\/\?\&\=\%]+\Z/
        # ^ seems like a valid url with protocol missing
        self.url = 'http://' + url # add protocol
      end
    end
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
end
