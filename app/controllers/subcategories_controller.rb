class SubcategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :set_category, only: %i(new create)

  def index
    @subcategories = Category.find(params[:id]).subcategories
  end

  def new
    return unless make_sure_admin_signed_in

    @subcategory = Subcategory.new category: @category
  end

  def create
    return unless make_sure_admin_signed_in

    @subcategory = @category.subcategories.create subcategory_params

    redirect_to_resource_if_valid @subcategory
  end

  def delete
    return unless make_sure_admin_signed_in

  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def subcategory_params
    params.require(:subcategory).permit(:name)
  end
end
