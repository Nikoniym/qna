class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_answer, only: %i[show edit update destroy]
  before_action :find_question, only: %i[create]

  def edit
  end

  def create
    @answers = @question.answers
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to question_path(@question)
    else
      @question.reload
      @answers = @question.answers
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    question = @answer.question
    @answer.destroy
    flash[:notice] = 'Your answer successfully destroy'
    redirect_to question_path(question)
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
