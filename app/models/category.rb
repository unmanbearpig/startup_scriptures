class Category < ActiveRecord::Base
  include BaseCategory

  has_many :subcategories, dependent: :destroy
  has_many :links, through: :subcategories, dependent: :destroy
  has_many :user_category_positions, dependent: :destroy

  validates :name, uniqueness: true

  def to_s
    name
  end
end
