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

  $('.link-star').on 'ajax:success', (e, data, status, xhr) ->
    console.log('on star')

  $('link-star-empty').on 'ajax:success', (e, data, status, xhr) ->
    console.log('on empty star')

  $('.categories-grid').equalizer({columns: ' .category-box'})

  resizeCategoryBar = () ->
    if $(window).width() > 750
      $('.search-bar').width(275)
      $('.categories-tabs').width($(window).width() - 306)
    else
      $('.search-bar').width($(window).width() - 20)
      $('.categories-tabs').width($(window).width() - 20)

  resizeCategoryBar()

  $(window).resize () ->
    resizeCategoryBar()
