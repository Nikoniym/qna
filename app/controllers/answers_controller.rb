class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[edit update destroy set_best]
  before_action :find_question, only: :create

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    flash.now[:notice] = 'Your answer successfully created' if @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = 'Your answer successfully update'
    else
      flash.now[:alert] = "You can't update someone else's answer"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer successfully destroy'
    else
      flash.now[:alert] = "You can't delete someone else's answer"
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best!
      flash.now[:notice] = 'The answer was set best successfully'
    else
      flash.now[:alert] = "You can't set the best answer not for your question"
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
