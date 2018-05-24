require 'rails_helper'

feature 'Create the answer to the questions', %q{
  In order to get answers to the questions from community
  As an authenticated user
  I want to be able to ask the answer to the questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user to create the answer to the questions with valid parameter', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.', 'text text text'
    expect(page).to have_field('Body', with: '')
  end

  scenario 'Authenticated user to create the answer to the questions with invalid parameter', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user try to create the answer to the questions' do
    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end