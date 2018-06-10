class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "comment_on_the_question_sheet_#{params['question_id']}"
  end
end