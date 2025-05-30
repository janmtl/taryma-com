window.change_bgimg = (source_elt, target_elt) ->
  target_elt.css('background-image', 'url(' + source_elt.data('imgurl') + ')')

jQuery ->
  $('.dropdown-toggle').dropdown()
  $('.dataTable').dataTable
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    sPaginationType: "bootstrap"
  $('ul.sortable').sortable
    axis: 'y'
    update: ->
      $.post($(this).data('update'), $(this).sortable('serialize'))