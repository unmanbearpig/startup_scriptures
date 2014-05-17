reorderSubcategories = (category_ids) ->
  $.post(gon.reorder_subcategories_path, {subcategory_ids: category_ids})

$(document).ready () ->
  selector = ".subcategories-list.sortable"
  handle_selector = '.subcategory-handle'

  $( selector ).sortable({
    handle: handle_selector,
    revert: 100,
    tolerance: 'pointer',
    placeholder: 'category-placeholder thumbnail',
    forcePlaceholderSize: true,
    beforeStop: (event, ui) ->
      subcategoriesOrder = $(selector).sortable('toArray', { attribute: 'data-subcategory-id'})
      reorderSubcategories(subcategoriesOrder)
  })
  $( handle_selector ).disableSelection()
