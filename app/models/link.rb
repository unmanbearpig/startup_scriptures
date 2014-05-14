class Link < ActiveRecord::Base
  validates :title, presence: true, allow_blank: false
  validates :url, presence: true, allow_blank: false # TODO: validate url format
  validates :subcategory_id, presence: true

  belongs_to :subcategory
  belongs_to :category
end
