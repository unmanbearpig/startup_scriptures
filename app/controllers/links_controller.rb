class LinksController < ApplicationController
  before_action :find_subcategory, only: %i(new create)

  def new
    @link = @subcategory.links.new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private

  def find_subcategory
    @subcategory ||= Subcategory.find(params[:subcategory_id])
  end
end
