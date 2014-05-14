class CategoriesController < ApplicationController
  layout 'with_categories_header'

  include AuthHelper

  def index
    render layout: 'with_header'
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    return unless make_sure_admin_signed_in
    @category = Category.new
    render layout: 'with_header'
  end

  def create
    return unless make_sure_admin_signed_in
    category = Category.create(category_params)

    if category.valid?
      redirect_to category
    else
      flash_messages_from_errors(category.errors)
      redirect_to :back
    end
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

  private

  def category_params
    params.require(:category).permit(:name)
  end

end
