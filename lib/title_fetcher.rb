class TitleFetcher
  attr_reader :url

  def initialize url
    @url = url
  end

  def title
    @title ||= doc.title
  end

  def async_title &block
    Thread.new { yield(title) }
  end

  def errors
    @errors ||= []
  end

  def success?
    errors.empty?
  end

  private

  def response
    @response ||= fetch
  end

  def fetch
    response = Typhoeus.get(url, followlocation: true)
    if response.return_code == :ok
      return response.body
    else
      errors << response.return_message
      return nil
    end
  end

  def doc
    @doc ||= Nokogiri::HTML.parse(response)
  end
end
