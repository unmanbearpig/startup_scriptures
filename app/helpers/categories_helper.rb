module CategoriesHelper
  def categories
    if admin_signed_in?
      @categories ||= Category.ordered
    else
      @categories ||= Category.displayed.ordered
    end
  end

  def current_category
    return @category if defined?(@category)
    nil
  end

  def current_category? category
    current_category == category
  end

  def edit_category_dropdown
    if admin_signed_in?
      menu_items = [['Edit category', edit_category_path(@category)],
                    ['Delete category', category_path(@category), {
                       'data-confirm' => 'Are you sure you want to delete this category?',
                       method: :delete }],
                    :separator,
                    ['New subcategory', new_category_subcategory_path(@category)]]

      menu_button 'Edit category', :small, menu_items
    end
  end
end
