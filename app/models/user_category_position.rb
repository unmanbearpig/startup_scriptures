class UserCategoryPosition < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  validates :category_id, uniqueness: {scope: :user_id}
  validates :position, uniqueness: {scope: [:user_id, :category_id]}


  acts_as_list
end
