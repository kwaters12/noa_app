$ ->
  console.log($('.brokerages_with_autocomplete').data('autocompleteurl'))
  $('.brokerages_with_autocomplete').autocomplete
    source: $('.brokerages_with_autocomplete').data('autocompleteurl')
  $('.sub_brokerages_with_autocomplete').autocomplete
    source: $('.sub_brokerages_with_autocomplete').data('autocompleteurl')
    # source: (request, response) ->
    #   $.ajax
    #     url: $('.brokerages_with_autocomplete').data('autocompleteurl')
    #     dataType: 'json'
    #     data:
    #       name: request.term
    #     error: (xhr) ->
    #         alert("An error occured: " + xhr.status + " " + xhr.statusText)
    #     success: (data) ->
    #       response(data)
        

  $('.datepicker').datepicker
    format: 'YYYY/MM/DD'
