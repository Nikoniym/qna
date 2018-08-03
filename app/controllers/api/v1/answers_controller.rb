class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: :show

  def index
    respond_with(@question.answers)
  end

  def show
    respond_with(@answer, serializer: ShowAnswerSerializer)
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_resource_owner)
  end
end