class Category < ActiveRecord::Base
  include BaseCategory

  has_many :subcategories
end
