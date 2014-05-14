class CategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :make_sure_admin_signed_in, except: %i(index show)

  def index
    render layout: 'with_header'
  end

  def show
    @category = Category.find(params[:id])
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
  end

  def edit
  end

  def update
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

end
