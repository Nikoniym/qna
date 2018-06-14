@actionCable = ->
  App.cable.subscriptions.create "QuestionsChannel", {
    connected: ->
      console.log 'connected question'
      @follow()


    follow: ->
      @perform 'follow'

    received: (data) ->
      $('.questions-list').append data
  }

  App.cable.subscriptions.create "AnswersChannel", {
    connected: ->
      console.log 'connected answers'
      @follow()

    follow: ->
      questionId = $('.question').data('question-id')
      console.log questionId
      @perform 'follow', question_id: questionId

    received: (data) ->
      if data.answer.user_id != gon.user_id
        console.log 'responce answer'
        console.log App.cable.subscriptions['subscriptions']

        $(".answers-list").append(JST["templates/answer"]
                                      answer: data.answer,
                                      like_count:data.like_count,
                                      attachments: data.attachments,
                                      question_user_id: data.question_user_id )

        ajaxRequest()
  }

  App.cable.subscriptions.create "CommentsChannel", {
    connected: ->
      console.log 'connected comments'
      @follow()

    follow: ->
      questionId = $('.question').data('question-id')
      console.log questionId
      @perform 'follow', question_id: questionId

    received: (data) ->
      if data.comment.user_id != gon.user_id
        console.log 'responce comment'
        $(data.element + ' ul').append(JST["templates/comment"]({comment: data.comment}))
  }

$(document).on 'turbolinks:load', ->
  App.cable.subscriptions['subscriptions'] = []
  actionCable()
  console.log App.cable.subscriptions['subscriptions']