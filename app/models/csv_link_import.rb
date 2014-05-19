require 'csv'

class CsvLinkImport
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  validates :file_path, presence: true, allow_blank: false
  validate :validate_links

  attr_accessor :file_path

  def options
    @options ||= {headers: :first_line}
  end

  def save
    links.reduce(true) { |result, link| link.save && result }
  end

  def links
    return @links if defined?(@links)

    @links = []
    CSV.foreach file_path, options do |row|
      hash = row.to_hash
      hash['category_name'] = hash['category'] if hash.has_key?('category')
      hash['subcategory_name'] = hash['subcategory'] if hash.has_key?('subcategory')

      link = LinkImport.new(hash)
      @links << link
    end
    @links
  end

  def validate_links
    if links.nil? || links.empty?
      errors.add(:csv, 'Could not read csv file')
    end
    links.each { |link| validate_link(link) }
  end

  def validate_link link
    unless link.valid?
      link.errors.full_messages.each do |msg|
        errors.add(link.url, msg)
      end
    end
  end
end
