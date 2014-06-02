class Category < ActiveRecord::Base
  include BaseCategory

  has_many :subcategories, dependent: :destroy
  has_many :links, through: :subcategories, dependent: :destroy

  has_one :category_position, dependent: :destroy

  validates :name, uniqueness: true

  def self.ordered order = :asc
    fail InvalidArgument.new('Invalid order') unless %i(asc desc).include?(order)

    Category.joins("LEFT JOIN category_positions
ON category_positions.category_id = categories.id")
      .order("category_positions.position #{order}")
  end

  def self.set_order categories_array
    categories_array.each_index do |index|
      category = categories_array[index]
      position = index + 1
      CategoryPosition.where(category: category)
        .first_or_create
        .update(position: position)
    end

  end

  def ordered_subcategories order = :asc
    fail InvalidArgument.new('Invalid order') unless %i(asc desc).include?(order)

    subcategories.joins("LEFT JOIN category_subcategory_positions
ON category_subcategory_positions.subcategory_id = subcategories.id")
      .order("category_subcategory_positions.position #{order}")
  end

  def set_subcategory_order subcategories_array
    subcategories_array.each_index do |index|
      subcategory = subcategories_array[index]
      position = index + 1

      CategorySubcategoryPosition
        .where(category: self, subcategory: subcategory)
        .first_or_create
        .update(position: position)
    end
  end

  def to_s
    name
  end
end
