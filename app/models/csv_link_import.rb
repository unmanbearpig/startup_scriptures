class CsvLinkImport
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  validates :file_path, presence: true, allow_blank: false
  validate :validate_links

  attr_accessor :file_path, :create_categories

  def options
    @options ||= {
      remove_unmapped_keys: true,
      downcase_header: true,
      key_mapping: {
        category: :category_name,
        category_name: :category_name,

        subcategory: :subcategory_name,
        subcategory_name: :subcategory_name,

        title: :title,

        link: :url,
        url: :url,

        tags: :tags,
        author: :author
      }
    }
  end

  def create_categories?
    @create_categories || false
  end

  def create_categories= bool
    @create_categories = bool
  end

  def save
    links.reduce(true) { |result, link| link.save && result }
  end

  def links
    return @links if defined?(@links)

    @links = []

    SmarterCSV.process(file_path, options) do |chunk|
      chunk.each do |row|
        link = LinkImport.new(row)
        link.create_categories = create_categories
        @links << link
      end
    end

    @links
  end

  def valid_links
    links.select { |l| l.valid? }.map(&:link)
  end

  def validate_links
    if links.nil? || links.empty?
      errors[:base] << 'An error occured while reading CSV file'
    end

    links.each { |link| validate_link(link) }
  end

  def validate_link link
    if link.nil?
      errors.add(:link, 'could not be created')
      return
    end

    unless link.valid?
      link.errors.full_messages.each do |msg|
        errors[:base] << ("Link #{link.url}: #{msg}")
      end
    end
  end
end
