module Valued
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[like dislike cancel_vote]
  end

  def like
    if @resource.can_like?(current_user)
      @resource.set_like!(current_user)

      respond_to do |format|
        format.json { render json: responce(:notice, "This #{resource_name} successfully like")  }
      end
    else
      respond_to do |format|
        format.json { render json: responce(:alert, "You have already put a like on this #{resource_name}"), status: :unprocessable_entity }
      end
    end
  end

  def dislike
    if @resource.can_dislike?(current_user)
      @resource.set_dislike!(current_user)
      respond_to do |format|
        format.json { render json: responce(:notice, "This #{resource_name} successfully dislike") }
      end
    else
      respond_to do |format|
        format.json { render json: responce(:alert, "You have already put a dislike on this #{resource_name}"), status: :unprocessable_entity }
      end
    end
  end

  def cancel_vote
    if @resource.can_cancel_vote?(current_user)
      @resource.delete_vote!(current_user)
      respond_to do |format|
        format.json { render json: responce(:notice, "Voting for the #{resource_name} is canceled successfully") }
      end
    else
      respond_to do |format|
        format.json { render json: responce(:alert, "Voting for a #{resource_name} cannot be cancelled"), status: :unprocessable_entity }
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

  def responce(key, message)
    { id: @resource.id, count: @resource.number, class: resource_name, key => message }
  end
end
