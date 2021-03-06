@ajaxRequest  = ->
  $('.rating-link').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail

    klass = '.' + data.class + '-' + data.id
    message = "<div class='mt-3'><p class='alert alert-success'>" + data.notice + "</p></div>"
    $(klass + ' .rating-count').first().text(data.count)
    $('.flash').html(message)

  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail
    if $.parseJSON(xhr.status) == 401
      message = "<div class='mt-3'><p class='alert alert-danger'>" + data + "</p></div>"
      $('.flash').html(message)
    else
      klass = '.' + data.class + '-' + data.id
      message = "<div class='mt-3'><p class='alert alert-danger'>" + data.alert + "</p></div>"
      $(klass + ' .rating-count').first().text(data.count)
      $('.flash').html(message)

  $('.add-comment-link').bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail

    message = "<div class='mt-3'><p class='alert alert-danger'>" + data + "</p></div>"
    $('.flash').html(message)

  $('#new_answer').bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail

    message = "<div class='mt-3'><p class='alert alert-danger'>" + data + "</p></div>"
    $('.flash').html(message)

  $('a').bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail
    if $.parseJSON(xhr.status) == 403
      message = "<div class='mt-3'><p class='alert alert-danger'>You are not authorized to access this page.</p></div>"
      $('.flash').html(message)

$ ->
  ajaxRequest()
