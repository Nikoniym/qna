@ajaxRequest  = ->
  $('.rating-link').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail

    klass = '.' + data.class + '-' + data.id
    message = "<div class='mt-3'><p class='alert alert-success'>" + data.notice + "</p></div>"
    $(klass + ' .rating-count').text(data.count)
    $('.flash').html(message)

  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail
    if $.parseJSON(xhr.status) == 401
      message = "<div class='mt-3'><p class='alert alert-danger'>" + data + "</p></div>"
      $('.flash').html(message)
    else
      klass = '.' + data.class + '-' + data.id
      message = "<div class='mt-3'><p class='alert alert-danger'>" + data.alert + "</p></div>"
      $(klass + ' .rating-count').text(data.count)
      $('.flash').html(message)


$(document).on 'turbolinks:load', ->
  ajaxRequest()
