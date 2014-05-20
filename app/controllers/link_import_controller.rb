class LinkImportController < ApplicationController
  layout 'with_header'

  before_action :make_sure_admin_signed_in

  def new
  end

  def import
    file = params[:file]

    if file.nil?
      flash[:alert] = 'File is not selected'
      return redirect_to :back
    end

    csv_links = CsvLinkImport.new file_path: file.path

    unless csv_links.valid?
      flash_messages_from_errors csv_links.errors
      return redirect_to :back
    end

    if csv_links.save
      links_count = csv_links.links.count
      flash[:notice] = "#{links_count} #{'link'.pluralize(links_count)} have been successfully imported"
    else
      flash[:alert] = 'Could not import links'
    end

    redirect_to :back
  end
end
