require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'facebook' do
    context 'if email exist' do
      before do
        request.env["omniauth.auth"] = mock_auth_hash(:facebook, 'test@gmail.com')
        get :facebook
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'returns User' do
        expect(controller.current_user).to be_a(User)
      end
    end

    context 'if email not exist' do
      before do
        request.env["omniauth.auth"] = mock_auth_hash(:facebook)
        get :facebook
      end

      it 'redirects to new_email_path' do
        expect(response).to redirect_to(new_email_path)
      end

      it 'create new user with valid params' do
        expect { post :create_user, params: { user: {email: 'test@ya.ru'} } }.to change(User, :count).by(1)
      end

      it 'redirects to user_facebook_omniauth_authorize_path' do
        post :create_user, params: { user: {email: 'test@ya.ru'} }
        expect(response).to redirect_to user_facebook_omniauth_authorize_path
      end

      it 'create new user with invalid params' do
        post :create_user, params: { user: {email: 'tesya.ru'} }
        expect(response).to render_template :new_email
      end
    end
  end

  describe 'twitter' do
    context 'if email exist' do
      before do
        request.env["omniauth.auth"] = mock_auth_hash(:twitter, 'test@ya.ru')
        get :twitter
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'returns User' do
        expect(controller.current_user).to be_a(User)
      end
    end

    context 'if email not exist' do
      before do
        request.env["omniauth.auth"] = mock_auth_hash(:twitter)
        get :twitter
      end

      it 'redirects to new_email_path' do
        expect(response).to redirect_to(new_email_path)
      end

      it 'create new user with valid params' do
        expect { post :create_user, params: { user: {email: 'test@ya.ru'} } }.to change(User, :count).by(1)
      end

      it 'redirects to user_facebook_omniauth_authorize_path' do
        post :create_user, params: { user: {email: 'test@ya.ru'} }
        expect(response).to redirect_to user_twitter_omniauth_authorize_path
      end

      it 'create new user with invalid params' do
        post :create_user, params: { user: {email: 'tesya.ru'} }
        expect(response).to render_template :new_email
      end
    end
  end
end