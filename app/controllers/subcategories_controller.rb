class SubcategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :set_category, only: %i(new create)
  before_action :make_sure_admin_signed_in

  def new
    @subcategory = Subcategory.new category: @category
  end

  def create
    @subcategory = @category.subcategories.create subcategory_params

    if @subcategory.valid?
      redirect_to @category
    else
      flash_messages_from_errors(@category.errors)
      redirect_to :back
    end
  end

  def delete
  end

  private

  def set_category
    @category ||= Category.find(params[:category_id])
  end

  def subcategory_params
    params.require(:subcategory).permit(:name)
  end
end
