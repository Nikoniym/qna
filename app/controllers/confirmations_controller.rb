class ConfirmationsController < Devise::ConfirmationsController
  skip_authorization_check

  private

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    root_path
  end
end