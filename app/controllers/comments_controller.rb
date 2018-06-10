class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.commentable_type && @comment.commentable_id
      type = @comment.commentable_type.downcase
      @element = ".#{type}-#{@comment.commentable_id} .#{type}-comments-list"
    end

    if @comment.commentable_type == 'Answer'
      @question_id = @comment.commentable.question_id
    else
      @question_id = @comment.commentable_id
    end

    flash.now[:notice] = 'Your comment successfully created' if @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comment_on_the_question_sheet_#{@question_id}",
        {comment: @comment, element: @element}
    )
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end
