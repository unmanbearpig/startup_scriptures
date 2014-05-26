require 'title_fetcher'

class TitleFetcherWorker
  include Sidekiq::Worker

  sidekiq_options retry: 30

  def perform link_id
    logger.info "BG Job: Fetching title for link #{link_id}"

    link = Link.find(link_id)
    return unless link

    fetch_link_title link
  end

  def fetch_link_title link
    return if link.title

    fetcher = TitleFetcher.new(link.url)
    if title = fetcher.title
      logger.info "BG Job: Fetched title #{title} for link #{link.id}, #{link.url}"

      link.title = title
      link.save!
    else
      msg = "Could not fetch the title for link #{link.id}, #{link}: #{fetcher.errors.join('; ')}"
      logger.error "BG Job: Fail! #{msg}"
      fail msg
    end
  end

  def logger
    @logger ||= Rails.logger
  end

end
