class LinksController < ApplicationController
  layout 'with_categories_header'

  before_action :find_subcategory, only: %i(new create)
  before_action :find_link, only: %i(destroy edit update)
  before_action :make_sure_admin_signed_in

  def search
    query = params[:q]
    if query.empty?
      flash[:alert] = 'Search query is empty'
      redirect_to root_path
    end

    tags_query = query.gsub(/\s+/, ' ').split(' ')

    @links = Link.tagged_with(tags_query, any: true, wild: true)
  end

  def new
    @link = @subcategory.links.new
  end

  def create
    @link = @subcategory.links.create link_params

    if @link.valid?
      flash[:notice] = "Link was created"
      redirect_to @subcategory.category
    else
      flash_messages_from_errors(@link.errors)
      redirect_to :back
    end
  end

  def destroy
    if @link.delete
      flash[:notice] = "Link was successfully deleted"
    else
      flash[:alert] = "Could not delete link"
    end

    redirect_to :back
  end

  def edit
  end

  def update
    @link.update(link_params)
    if @link.valid?
      flash[:notice] = "Link was updated successfully"
      redirect_to @link.category
    else
      flash_messages_from_errors(@link.errors)
      redirect_to :back
    end
  end

  private

  def find_link
    @link ||= Link.find(params[:id])
  end

  def find_subcategory
    @subcategory ||= Subcategory.find(params[:subcategory_id])
  end

  def link_params
    params.require(:link).permit(:url, :title, :tag_list)
  end
end
