class SavedLinksController < ApplicationController
  layout 'with_header'

  before_action :make_sure_user_signed_in

  def index
    @links = current_user.links
  end

  def create
    saved_link = current_user.save_link(link)

    if saved_link.valid?
      flash[:notice] = "Link was added to your reading list"
    else
      flash_messages_from_errors(saved_link.errors)
    end

    redirect_to :back
  end

  def delete
    result = current_user.delete_link(link)

    if result
      flash[:notice] = "The link was removed from your reading list"
    else
      flash[:alert] = "Could not remove the link from your reading list"
    end

    redirect_to :back
  end

  private

  def make_sure_user_signed_in
    unless user_signed_in?
      flash[:alert] = 'You have to sign in to use reading list'
      redirect_to new_user_session_path
    end
  end

  def link
    @link ||= Link.find(params[:link_id])
  end
end
