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
        $(".answers-list").append(JST["templates/answer"]
                                      answer: data.answer,
                                      like_count:data.like_count,
                                      attachments: data.attachments,
                                      question_user_id: data.question_user_id )

        ajaxRequest()
  }

$(document).on 'turbolinks:load', ->
  actionCable()

