class CategoriesController < ApplicationController
  layout 'with_categories_header'

  helper :categories

  def index
    render layout: 'with_header'
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    return unless make_sure_admin_signed_in
  end

  def create
    return unless make_sure_admin_signed_in
  end

  def destroy
    return unless make_sure_admin_signed_in
  end

  def edit
    return unless make_sure_admin_signed_in
  end

  def update
    return unless make_sure_admin_signed_in
  end
end
