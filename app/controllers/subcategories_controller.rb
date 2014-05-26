class SubcategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :find_category, only: %i(new create)
  before_action :find_subcategory, only: %i(destroy edit update)
  before_action :make_sure_admin_signed_in

  def new
    @subcategory = @category.subcategories.new
  end

  def create
    @subcategory = @category.subcategories.create subcategory_params

    if @subcategory.valid?
      flash[:notice] = "Subcategory #{@subcategory.name} was created"
      redirect_to @category
    else
      flash_messages_from_errors(@subcategory.errors)
      redirect_to :back
    end
  end

  def destroy
    if @subcategory.destroy
      flash[:notice] = 'Subcategory was successfully deleted'
    else
      flash[:alert] = 'Could not delete subcategory'
    end
    redirect_to :back
  end

  def edit
  end

  def update
    @subcategory.update(subcategory_params)
    if @subcategory.valid?
      flash[:notice] = "Subcategory '#{@subcategory.name}' was successfully updated"
      redirect_to @subcategory.category
    else
      flash_messages_from_errors(@subcategory.errors)
      redirect_to :back
    end
  end

  private

  def find_subcategory
    @subcategory ||= Subcategory.find(params[:id])
  end

  def find_category
    @category ||= Category.find(params[:category_id])
  end

  def subcategory_params
    params.require(:subcategory).permit(:name)
  end
end
