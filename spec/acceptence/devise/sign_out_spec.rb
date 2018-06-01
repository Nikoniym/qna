require 'rails_helper'

feature 'User log_out', %q{
  In order to be able exit form profil
  As an authenticated user
  I want be able to log out
 } do
  given(:user) { create(:user) }

  scenario 'Registered user try to log out' do
    sign_in(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign out' do
    visit root_path
    expect(page).to_not have_content 'Log out.'
  end
end