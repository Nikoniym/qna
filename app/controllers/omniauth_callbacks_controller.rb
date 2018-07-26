class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def facebook
    omniauth_callback('Facebook')
  end

  def twitter
    omniauth_callback('Twitter')
  end


  def omniauth_callback(provider)
    request.env['omniauth.auth'].info.email = session['devise.user_email'] unless request.env['omniauth.auth'].info.email
    @user = User.find_for_ouath(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session['devise.provider'] = request.env['omniauth.auth'].provider
      redirect_to new_email_path
    end
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      session['devise.user_email'] = @user.email
      redirect_to "/users/auth/#{session['devise.provider']}"
    else
      render :new_email
    end
  end

  def new_email
    @user = User.new
  end

  private

  def user_params
    password = Devise.friendly_token
    params.require(:user).permit(:email).merge(password: password, password_confirmation: password)
  end
end