reorderCategories = (category_ids) ->
  $.post(gon.reorder_categories_path, {category_ids: category_ids})

$(document).ready () ->
  selector = ".categories-grid.sortable"
  handle_selector = '.category-handle'

  $( selector ).sortable({
    handle: handle_selector,
    revert: 100,
    tolerance: 'pointer',
    placeholder: 'category-placeholder col-md-3 thumbnail',
    forcePlaceholderSize: true,
    beforeStop: (event, ui) ->
      categoriesOrder = $(selector).sortable('toArray', { attribute: 'data-category-id'})
      reorderCategories(categoriesOrder)
  })
  $( handle_selector ).disableSelection()
