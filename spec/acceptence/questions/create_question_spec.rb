require 'rails_helper'

feature 'Create questions', %q{
  In order to get questions from community
  As an authenticated user
  I want to be able to ask the questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the questions with valid parameter' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask question'

    fill_in 'Title', with: 'Test questions'
    fill_in 'Text', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Authenticated user create the questions with invalid parameter' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask question'

    fill_in 'Title', with: ''
    fill_in 'Text', with: ''
    click_on 'Create'

    expect(page).to have_content "Title can't be blank", "Body can't be blank"
  end

  scenario 'Non-authenticated user try to create questions' do
    visit '/questions'
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end