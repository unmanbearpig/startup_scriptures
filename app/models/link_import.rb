class LinkImport
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :category_name, :subcategory_name, :title, :url, :tags
  attr_reader :category, :subcategory

  validates :category, presence: true
  validates :subcategory, presence: true
  validates :title, presence: true
  validates :url, presence: true

  def save
    link.save!
  end

  def link
    return nil unless subcategory

    @link ||= subcategory.links.where(url: url).first_or_initialize
    @link.tag_list = tags
    @link.title = title
    @link
  end

  def category
    @category ||= Category.where(name: category_name).first
  end

  def subcategory
    return nil unless category
    @subcategory ||= category.subcategories.where(name: subcategory_name).first
  end
end
