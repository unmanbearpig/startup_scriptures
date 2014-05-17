module SubcategoriesHelper
  def subcategories(category)
    @subcategories ||= if user_signed_in?
                         current_user.ordered_subcategories(category)
                       else
                         category.subcategories
                       end
  end

  def edit_subcategory_dropdown(subcategory)
    if admin_signed_in?
      menu_items = [['Edit subcategory', edit_subcategory_path(subcategory)],
                    ['Delete subcategory', subcategory_path(subcategory), {
                       'data-confirm' => 'Are you sure you want to delete this subcategory?',
                       method: :delete }],
                    :separator,
                    ['New link', new_subcategory_link_path(subcategory)]]

      menu_button 'Edit subcategory', :xs, menu_items
    end
  end
end
