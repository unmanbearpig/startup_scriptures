reorderLinks = (reorderPath, linkIds) ->
  $.post(reorderPath, {link_ids: linkIds})

$(document).ready () ->
  selector = ".link-list"
  handle_selector = '.link-handle'

  $( selector ).sortable({
    handle: handle_selector,
    revert: 100,
    tolerance: 'pointer',
    placeholder: 'category-placeholder thumbnail',
    forcePlaceholderSize: true,
    beforeStop: (event, ui) ->
      linksOrder = $(ui.item.parents(selector)).sortable('toArray', { attribute: 'data-link-id'})
      subcategoryElement = ui.item.parents('.subcategory-list-item')[0]
      reorderPath = $(subcategoryElement).attr('data-reorder-links-path')
      reorderLinks(reorderPath, linksOrder)
  })
  $( handle_selector ).disableSelection()
