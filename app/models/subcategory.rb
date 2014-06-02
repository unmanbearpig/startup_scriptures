class Subcategory < ActiveRecord::Base
  include BaseCategory
  belongs_to :category
  has_many :links, dependent: :destroy

  has_one :category_subcategory_position, dependent: :destroy

  validates :category, presence: true

  def to_s
    name
  end
end
