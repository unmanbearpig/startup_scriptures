class CategorySubcategoryLinkPosition < ActiveRecord::Base
  belongs_to :category
  belongs_to :subcategory
  belongs_to :link

  validates :link_id, uniqueness: {scope: %i(category_id subcategory_id)}
  validates :position, uniqueness: {scope: [:category_id, :subcategory_id, :link_id]}

  acts_as_list
end
