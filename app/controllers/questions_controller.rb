class QuestionsController < ApplicationController
  include Valued

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.all

    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      @question.attachments.build
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully destroy'
    else
      redirect_to @question, alert: "You can't delete someone else's question"
    end
  end

  private

  def publish_question
    return if @question.errors.any?
    # gon_user
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
            partial: 'questions/question',
            locals: { question: @question }
        )
    )
  end

  def attachment_build
    @question.attachments.build
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
