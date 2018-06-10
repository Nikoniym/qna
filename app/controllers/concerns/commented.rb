module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_resource_for_comment, only: :new_comment
  end

  def new_comment
    @comment = @resource.comments.new
  end

  private

  def resource_id
    "#{controller_name.singularize}_id".to_sym
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_resource_for_comment
    @resource = model_klass.find(params[resource_id])
  end
end