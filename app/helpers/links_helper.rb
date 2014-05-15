module LinksHelper
  def edit_link_button
    menu_items = [['Edit', edit_link(@link)],
                  ['Delete', de]]

    menu_button 'Edit link', :xs, menu_items
  end
end
