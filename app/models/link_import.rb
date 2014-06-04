class LinkImport
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :category_name, :subcategory_name, :title, :url, :tags, :author
  attr_reader :category, :subcategory

  validates :category, presence: true
  validates :subcategory, presence: true
  validates :url, presence: true

  validate :validate_link

  attr_writer :create_categories
  def create_categories?
    @create_categories ||= false
  end

  def save
    link.save
  end

  def link
    return nil unless subcategory

    @link ||= subcategory.links.where(url: Link.fix_url(url)).first_or_initialize
    @link.tag_list = tags
    @link.title = title
    @link.author = author
    @link
  end

  def category
    return @category if defined?(@category)

    @category_count = 0 unless defined?(@category_count)
    @category_count += 1

    category_relation = Category.where(name: category_name)

    @category = create_categories? ? category_relation.first_or_create : category_relation.first

    @category
  end

  def subcategory
    return nil unless category
    return @subcategory if defined?(@subcategory)

    subcategory_relation = category.subcategories.where(name: subcategory_name)

    @subcategory = create_categories? ? subcategory_relation.first_or_create : subcategory_relation.first
  end

  def validate_link
    return false unless link

    unless link.valid?
      link.errors.each_entry do |e|
        errors.add(e[0], e[1])
      end
    end
  end
end
