class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "answer_for_question_#{params['question_id']}"
  end
end