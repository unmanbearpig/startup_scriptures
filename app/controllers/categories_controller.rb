class CategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :make_sure_admin_signed_in, except: %i(index show)
  before_action :find_category, only: %i(show edit update delete)

  def index
    render layout: 'with_header'
  end

  def show
  end

  def new
    @category = Category.new
    render layout: 'with_header'
  end

  def create
    @category = Category.create category_params
    redirect_to_resource_if_valid @category
  end

  def destroy
    @category.delete
    redirect_to categories_path
  end

  def edit
  end

  def update
    @category.update(category_params)
    redirect_to_resource_if_valid @category
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
