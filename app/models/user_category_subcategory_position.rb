class UserCategorySubcategoryPosition < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :subcategory

  validates :category_id, uniqueness: {scope: :user_id}
  validates :subcategory_id, uniqueness: {scope: [:category_id, :subcategory_id]}
  validates :position, uniqueness: {scope: [:user_id, :category_id, :subcategory_id]}

  acts_as_list
end
