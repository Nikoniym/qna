module Valued
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[put_like put_dislike cancel_vote]
  end

  def put_like
    if !current_user.author_of?(@resource) && !@resource.set_like?(current_user)
      @resource.set_like!(current_user)
      respond_to do |format|
        format.json { render json: { object: @resource.rating, notice: "This #{resource_name} successfully like" } }
      end
    else
      respond_to do |format|
        format.json { render json: { object: @resource.rating, alert: "You have already put a like on this #{resource_name}" }, status: :unprocessable_entity }
      end
    end
  end

  def put_dislike
    if !current_user.author_of?(@resource) && !@resource.set_dislike?(current_user)
      @resource.set_dislike!(current_user)
      respond_to do |format|
        format.json { render json: { object: @resource.rating, notice: "This #{resource_name} successfully dislike" } }
      end
    else
      respond_to do |format|
        format.json { render json: { object: @resource.rating, alert: "You have already put a dislike on this #{resource_name}" }, status: :unprocessable_entity }
      end
    end
  end

  def cancel_vote
    if !current_user.author_of?(@resource) && (@resource.set_dislike?(current_user) || @resource.set_like?(current_user))
      @resource.delete_vote!(current_user)
      respond_to do |format|
        format.json { render json: { object: @resource.rating, notice: "Voting for the #{resource_name} is canceled successfully" } }
      end
    else
      respond_to do |format|
        format.json { render json: { object: @resource.rating, alert: "Voting for a #{resource_name} cannot be cancelled" }, status: :unprocessable_entity }
      end
    end
  end

  private

  def resource_name
    controller_name.singularize
  end

  def model_klass
    controller_name.classify.constantize
  end
  def set_resource
    @resource = model_klass.find(params[:id])
  end
end
