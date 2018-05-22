require 'rails_helper'

feature 'Create the answer to the questions', %q{
  In order to get answers to the questions from community
  As an authenticated user
  I want to be able to ask the answer to the questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  scenario 'Authenticated user to create the answer to the questions' do
    sign_in(user)

    visit "/questions/#{question.id}"

    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-authenticated user try to create the answer to the questions' do
    visit "/questions/#{question.id}"
    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end