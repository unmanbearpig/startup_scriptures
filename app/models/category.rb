class Category < ActiveRecord::Base
  include BaseCategory

  has_many :subcategories, dependent: :destroy
  has_many :links, through: :subcategories
  has_many :user_category_positions

  validates :name, uniqueness: true

  def to_s
    name
  end
end
