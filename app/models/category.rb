class Category < ActiveRecord::Base
  include BaseCategory

  has_many :subcategories
  has_many :links, through: :subcategories
end
