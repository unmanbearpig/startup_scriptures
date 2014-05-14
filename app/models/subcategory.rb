class Subcategory < ActiveRecord::Base
  include BaseCategory
  belongs_to :category
  has_many :links
end
