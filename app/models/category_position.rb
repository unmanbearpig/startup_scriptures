class CategoryPosition < ActiveRecord::Base
  belongs_to :category

  validates :category_id, uniqueness: true
  validates :position, uniqueness: {scope: [:category_id]}

  acts_as_list
end
