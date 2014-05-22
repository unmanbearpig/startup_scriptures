class Subcategory < ActiveRecord::Base
  include BaseCategory
  belongs_to :category
  has_many :links

  def to_s
    name
  end
end
