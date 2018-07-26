class AnswersController < ApplicationController
  include Valued
  include Commented

  before_action :authenticate_user!
  before_action :find_answer, only: %i[edit update destroy set_best]
  before_action :find_question, only: :create
  after_action :publish_answer, only: :create

  respond_to :js

  authorize_resource

  def edit
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    respond_with(@answer.set_best!)
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
