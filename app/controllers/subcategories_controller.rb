class SubcategoriesController < ApplicationController
  layout 'with_categories_header'

  before_action :find_category, only: %i(new create)
  before_action :find_subcategory, only: %i(show reorder_links destroy edit update)
  before_action :make_sure_admin_signed_in, except: %i(show)

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

  def show
  end

  def reorder_links
    links_ids = params[:link_ids]

    respond_to do |format|
      format.json do
        links_array = links_ids
          .reject(&:empty?)
          .map(&:to_i)
          .map { |id| Link.find(id) }

        render :json => { success: @subcategory.set_link_order(links_array) }
      end
    end
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
    @subcategory ||= Subcategory.find(params[:id] || params[:subcategory_id])
  end

  def find_category
    @category ||= Category.find(params[:category_id])
  end

  def subcategory_params
    params.require(:subcategory).permit(:name)
  end
end
