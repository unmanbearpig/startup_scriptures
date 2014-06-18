class Subcategory < ActiveRecord::Base
  include BaseCategory
  belongs_to :category
  has_many :links, dependent: :destroy

  has_one :category_subcategory_position, dependent: :destroy

  validates :category, presence: true

  def to_s
    name
  end

  def ordered_links order = :asc
    fail InvalidArgument.new('Invalid order') unless %i(asc desc).include?(order)

    links.joins("LEFT JOIN category_subcategory_link_positions
ON category_subcategory_link_positions.link_id = links.id")
      .order("category_subcategory_link_positions.position #{order}")
  end

  def set_link_order links_array
    links_array.each_index do |index|
      link = links_array[index]
      position = index + 1

      CategorySubcategoryLinkPosition
        .where(category: self.category, subcategory: self, link: link)
        .first_or_create
        .update(position: position)
    end

  end
end
