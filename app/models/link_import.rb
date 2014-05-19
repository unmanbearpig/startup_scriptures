class LinkImport
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :category_name, :subcategory_name, :title, :url, :tags
  attr_reader :category, :subcategory

  validates :category, presence: true
  validates :subcategory, presence: true
  validates :title, presence: true
  validates :url, presence: true
  validate :validate_link

  def save
    puts 'save'
    link.save!
  end

  def link
    @link ||= subcategory.links.where(url: url).first_or_initialize
    @link.tag_list = tags
    @link.title = title
    @link
  end

  def category
    @category ||= Category.where(name: category_name).first
  end

  def subcategory
    @subcategory ||= category.subcategories.where(name: subcategory_name).first
  end

  def validate_link
    unless link.valid?
      link.errors.full_messages.each do |msg|
        errors.add(:link, msg)
      end
    end
  end
end
