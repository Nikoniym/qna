class AnswersController < ApplicationController
  include Valued
  include Commented

  before_action :authenticate_user!
  before_action :find_answer, only: %i[edit update destroy set_best]
  before_action :find_question, only: :create
  after_action :publish_answer, only: :create

  respond_to :js

  def edit
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      respond_with(@answer)
    else
      flash.now[:alert] = "You can't update someone else's answer"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      respond_with(@answer.destroy)
    else
      flash.now[:alert] = "You can't delete someone else's answer"
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      respond_with(@answer.set_best!)
    else
      flash.now[:alert] = "You can't set the best answer not for your question"
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "answer_for_question_#{@answer.question_id}",
        {answer: @answer, like_count: @answer.number, attachments: @answer.attachments, question_user_id: @answer.question.user_id}
    )
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file]).merge(user: current_user)
  end
end
