class CategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :make_sure_admin_signed_in, except: %i(index show)
  before_action :find_category, except: %i(index new create reorder)

  def index
    gon.push({reorder_categories_path: reorder_categories_path})

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

  def reorder
    category_ids = params[:category_ids]

    respond_to do |format|
      format.json do
        categories_array = category_ids
          .reject(&:empty?)
          .map(&:to_i)
          .map { |id| Category.find(id) }

        render :json => { success: current_user.set_category_order(categories_array) }
      end
    end
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
