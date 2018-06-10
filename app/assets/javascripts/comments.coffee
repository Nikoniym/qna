#@commentError  = ->
#  $('.add-comment-link').bind 'ajax:error', (e) ->
#    [data, status, xhr] = e.detail
#
#    message = "<div class='mt-3'><p class='alert alert-danger'>" + data + "</p></div>"
#    $('.flash').html(message)
#
#$(document).on 'turbolinks:load', ->
#  commentError()