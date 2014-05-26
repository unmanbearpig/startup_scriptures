require 'title_fetcher'

class Link < ActiveRecord::Base
  validates :url, presence: true, allow_blank: false
  validates :subcategory_id, presence: true

  validate :validate_url_format

  belongs_to :subcategory

  before_validation :fix_url

  after_save :fetch_title_and_save!

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

  def fetch_title_and_save!
    fetch_title_async do
      save! if title
    end
  end

  def fetch_title_async &block
    if title.nil? || title.empty?
      TitleFetcher.new(url).async_title do |title|
        self.title = title
        yield
      end
    end
  end

  def to_s
    return title unless title.nil? || title.empty?
    return hostname
  end
end
