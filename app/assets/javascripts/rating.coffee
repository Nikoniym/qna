ajaxRequest  = ->
  $('.rating-link').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail

    object = $.parseJSON(xhr.response).object
    message = $.parseJSON(xhr.response).notice

    klass = '.' + object.ratingable_type.toLowerCase() + '-' + object.ratingable_id

    message = "<div class='mt-3'><p class='alert alert-success'>" + message + "</p></div>"
    $(klass + ' .rating-count').text(object.rating_count)
    $('.flash').html(message)

  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail

    if $.parseJSON(xhr.status) == 401
      message = data
      message = "<div class='mt-3'><p class='alert alert-danger'>" + message + "</p></div>"
      $('.flash').html(message)
    else
      object = $.parseJSON(xhr.response).object
      message = $.parseJSON(xhr.response).alert

      klass = '.' + object.ratingable_type.toLowerCase() + '-' + object.ratingable_id

      message = "<div class='mt-3'><p class='alert alert-danger'>" + message + "</p></div>"
      $(klass + ' .rating-count').text(object.rating_count)
      $('.flash').html(message)

$(document).on('turbolinks:load', ajaxRequest)
