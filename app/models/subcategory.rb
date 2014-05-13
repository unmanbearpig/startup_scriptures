class Subcategory < ActiveRecord::Base
  include BaseCategory
  belongs_to :category
end
