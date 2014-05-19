class Link < ActiveRecord::Base
  validates :title, presence: true, allow_blank: false
  validates :url, presence: true, allow_blank: false
  validates :subcategory_id, presence: true

  validate :validate_url_format

  belongs_to :subcategory

  acts_as_taggable
  acts_as_votable

  def category
    subcategory.category
  end

  def validate_url_format
    unless url =~ /^#{URI.regexp(['http', 'https'])}$/
      errors.add(:url_format, 'is invalid')
    end
  end
end
