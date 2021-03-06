class LinksController < ApplicationController
  include ActionView::Helpers::TextHelper

  layout 'with_categories_header'

  before_action :find_subcategory, only: %i(new create)
  before_action :find_link, only: %i(edit update destroy upvote downvote)
  before_action :make_sure_admin_signed_in, only: %i(new create destroy edit update links_without_titles recent fetch_missing_titles)
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
    @link.build_promo_announcement
  end

  def create
    # we can't create it with promo announcement in one step because
    # promo_announcement has to have a link_id which is not created yet
    @link = @subcategory.links.create link_params.except('promo_announcement_attributes')
    @link.update link_params

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
    @link.build_promo_announcement unless @link.promo_announcement
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

  def fetch_missing_titles
    count = Link.fetch_missing_titles
    flash[:notice] = "Fetching #{pluralize(count, 'missing title')}"
    redirect_to :back
  end

  private

  def find_link
    @link ||= Link.find(params[:id])
  end

  def find_subcategory
    @subcategory ||= Subcategory.find(params[:subcategory_id])
  end

  def link_params
    params.require(:link).permit(:url, :title, :tag_list, :author, :description, promo_announcement_attributes: %i(id link_id is_visible message))
  end

  def make_sure_user_can_vote
    unless user_signed_in?
      flash[:alert] = "Please sign in to vote"
      redirect_to :back
    end
  end
end
