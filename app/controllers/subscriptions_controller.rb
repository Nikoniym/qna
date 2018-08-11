class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_subscription, only: :destroy

  respond_to :js

  authorize_resource

  def create
    respond_with(@subscription = Subscription.create(user: current_user, question: @question))
  end

  def destroy
    @question = @subscription.question
    respond_with(@subscription.destroy)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end