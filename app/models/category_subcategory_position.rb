class CategorySubcategoryPosition < ActiveRecord::Base
  belongs_to :category
  belongs_to :subcategory

  validates :subcategory_id, uniqueness: {scope: %i(category_id)}
  validates :position, uniqueness: {scope: [:category_id, :subcategory_id]}

  acts_as_list
end
