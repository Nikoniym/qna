require 'rails_helper'

feature 'User registration', %q{
  In order to be able registration new user
  As an not authenticated user
  I want be able to sign in
 } do
  scenario 'Go to the registration page by clicking on the Registration' do
    visit root_path
    click_on 'Registration'
    expect(current_path).to eq new_user_registration_path
  end

  scenario 'Registered user with valid parameter' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user with invalid parameter' do
    visit new_user_registration_path
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank", "Password can't be blank"
  end

end