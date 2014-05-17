class UserCategorySubcategoryPosition < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :subcategory

  validates :subcategory_id, uniqueness: {scope: %i(user_id category_id)}
  validates :position, uniqueness: {scope: [:user_id, :category_id, :subcategory_id]}

  acts_as_list
end
