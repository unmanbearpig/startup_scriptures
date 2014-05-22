class LinkImportController < ApplicationController
  layout 'with_header'

  before_action :make_sure_admin_signed_in

  def new
  end

  def import
    return unless csv_links

    if csv_links.save
      links_count = csv_links.links.count
      flash[:notice] = "#{links_count} #{'link'.pluralize(links_count)} have been successfully imported"
    else
      flash[:alert] = 'Could not import links'
    end

    @links = csv_links.valid_links
  end

  private

  def csv_links
    return nil unless file
    return @csv_links if defined?(@csv_links)

    @csv_links = CsvLinkImport.new file_path: file.path
    @csv_links.create_categories = create_categories
    unless @csv_links.valid?
      flash_messages_from_errors @csv_links.errors
      redirect_to :back
      return nil
    end

    @csv_links
  end

  def file
    return @file if @file || @file = params[:file]

    flash[:alert] = 'File is not selected'
    redirect_to :back
    return nil
  end

  def create_categories
    return  @create_categories || @create_categories = params[:create_categories] || false
  end
end
