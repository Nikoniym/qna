require 'rails_helper'

feature 'Authorization via providers', %q{
  In order to login or sign up
  As an authenticated user
  I want to use social network services
} do

  let(:user) { create(:user, email: 'user@temp.email') }
  let(:email) { 'test@gmail.com' }

  describe 'facebook' do
    scenario 'sign up user' do
      visit new_user_session_path

      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Email'

      fill_in 'Email', with: email
      click_on 'send'

      open_email(email)

      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'log in user' do
      auth = mock_auth_hash(:facebook, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end
  end

  describe 'twitter' do
    scenario 'sign up user' do
      visit new_user_session_path

      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Email'

      fill_in 'Email', with: email
      click_on 'send'

      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'log in user' do
      auth = mock_auth_hash(:twitter, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account.')
    end
  end
end