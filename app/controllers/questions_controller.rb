class QuestionsController < ApplicationController
  include Valued
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create
  before_action :build_answer, only: :show

  respond_to :html

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers.all
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with(@question.destroy)
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

  def build_answer
    @answer = @question.answers.build
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
