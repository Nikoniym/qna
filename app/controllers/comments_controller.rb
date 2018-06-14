class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :find_current_question
  after_action :set_element
  after_action :publish_comment, only: :create

  respond_to :js

  def create
    respond_with(@comment = Comment.create(comment_params))
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comment_on_the_question_sheet_#{@question_id}",
        {comment: @comment, element: @element}
    )
  end

  def set_element
    if @comment.commentable_type && @comment.commentable_id
      type = @comment.commentable_type.downcase
      @element = ".#{type}-#{@comment.commentable_id} .#{type}-comments-list"
    end
  end

  def find_current_question
    if @comment.commentable_type == 'Answer'
      @question_id = @comment.commentable.question_id
    else
      @question_id = @comment.commentable_id
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type).merge(user: current_user)
  end
end
