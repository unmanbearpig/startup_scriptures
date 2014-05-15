module LinksHelper
  def edit_link_button(link)
    if admin_signed_in?
      menu_items = [['Edit link', edit_link_path(link)],
                    ['Delete link', link_path(link), {
                       'data-confirm' => 'Are you sure you want to delete this link?',
                       method: :delete }],
                   ]

      menu_button 'Edit', :xs, menu_items
    end
  end
end
