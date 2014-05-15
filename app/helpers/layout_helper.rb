module LayoutHelper
  def menu_button title, size = nil, items
    button_class = case size
                   when :large then 'btn-lg'
                   when :small then 'btn-sm'
                   when :xs then 'btn-xs'
                   else ''
                   end

    menu_items = items.map do |item|
      if item.kind_of?(Array)
        item_hash = {
          title: item.first,
          url: item.second,
        }

        if item.count > 2
          item_hash[:options] = item.third
        end

        item_hash
      else
        item
      end
    end

    render partial: 'shared/menu_button', locals: {
      title: title,
      button_class: button_class,
      items: menu_items
    }
  end
end
