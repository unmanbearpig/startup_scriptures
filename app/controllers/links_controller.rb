class LinksController < ApplicationController
  layout 'with_categories_header'

  before_action :find_subcategory, only: %i(new create)
  before_action :find_link, only: %i(edit update destroy upvote downvote)
  before_action :make_sure_admin_signed_in, only: %i(new create destroy edit update links_without_titles recent)
  before_action :make_sure_user_can_vote, only: %i(upvote downvote unvote)

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
    if @link.destroy
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

  def upvote
    @link.upvote_by(current_user)
    redirect_to :back
  end

  def downvote
    @link.downvote_by(current_user)
    redirect_to :back
  end

  def unvote
    @link.unvote_by(current_user)
    redirect_to :back
  end

  def recent
    @links = Link.order(updated_at: :desc).take(50)
    render layout: 'with_header'
  end

  def links_without_titles
    @links = Link.no_title.all
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

  def make_sure_user_can_vote
    unless user_signed_in?
      flash[:alert] = "Please sign in to vote"
      redirect_to :back
    end
  end
end
