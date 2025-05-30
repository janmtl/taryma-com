# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# This example does an AJAX lookup and is in CoffeeScript
SetupTypeaheadsAndModals = ->
  #$('.typeahead').each ->
    #data_source = $(this).data('source')
    #$(this).typeahead(
      # source can be a function
      #source: (typeahead, query) ->
        # this function receives the typeahead object and the query string
        #$.ajax(
          #url: data_source
          #dataType: 'json'
          #data: 'query='+query
          # i'm binding the function here using CoffeeScript syntactic sugar,
          # you can use for example Underscore's bind function instead.
          #success: (data) =>
            # data must be a list of either strings or objects
            # data = [{'name': 'Joe', }, {'name': 'Henry'}, ...]
            #typeahead.process(data)
        #)
      # if we return objects to typeahead.process we must specify the property
      # that typeahead uses to look up the display value
      #property: 'name'
    #)
  $('form').on 'click', '.browse_fields', (event) ->
    $('#association-modal').data('source', $(this).data('source')).data('target', $(this).data('target')).data('title', $(this).data('title')).modal('show')


FillModal = ->
  target = $('#association-modal').data('target')
  source = $('#association-modal').data('source')
  query = $('#association-search').val()
  output = "Failed to reach server"
  $.ajax(
    url: source
    dataType: 'json'
    data: 'query='+query
    success: (data) =>
      output = "<ul class='modal-images'>"
      $.each data, (i,v) =>
        output += "<li>
          <div class='imgbox'><img src=\""+v.filename+"\"></div>
          <a href='#' onclick=\'
              $(\"input[id="+target+"]\").val(\""+escape(v.id)+"\"); 
              change_bgimg($(this), $(\".attachment[name="+target+"]\"));
              return false;\'
          data-dismiss='modal' data-imgurl='"+v.filename+"'>"+v.name+"</a>
          </li>"
      output += "</ul>"
    complete: =>
      $('.modal-body').html(output)
  )
  

jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $('#'+$(this).data('target')+'_destroy').val('1')
    $(this).closest('.attachment').hide()
    event.preventDefault()
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).prev('.attachments').append($(this).data('fields').replace(regexp, time))
    SetupTypeaheadsAndModals()
    event.preventDefault()
  SetupTypeaheadsAndModals()
  $('#association-modal').on 'shown', (event) ->
    $(this).find("#title").html($(this).data('title'))
    FillModal()
  $('#association-search').on 'keyup', (event) ->
    FillModal()
    
  