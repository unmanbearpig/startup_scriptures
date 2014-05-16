class CategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :make_sure_admin_signed_in, except: %i(index show)
  before_action :find_category, except: %i(index new create)

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
    if @category.delete
      flash[:notice] = 'Category was successfully deleted'
    else
      flash[:alert] = 'Could not delete category'
    end

    redirect_to categories_path
  end

  def edit
  end

  def update
    @category.update(category_params)
    redirect_to_resource_if_valid @category
  end

  def move
    position = params[:position]

    current_user.move_category(@category, position)
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
