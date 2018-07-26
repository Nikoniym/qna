require 'rails_helper'

feature 'Create questions', %q{
  In order to get questions from community
  As an authenticated user
  I want to be able to ask the questions
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user create the questions with valid parameter' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test questions'
    fill_in 'Text', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test questions'
    expect(page).to have_content 'text text text'
  end

  scenario 'Authenticated user create the questions with invalid parameter' do
    sign_in(user)

    visit questions_path

    click_on 'Ask question'

    fill_in 'Title', with: ''
    fill_in 'Text', with: ''
    click_on 'Create'

    expect(page).to have_content "Title can't be blank", "Body can't be blank"
  end

  scenario 'Non-authenticated user try to create questions' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end

  context "mulitple sessions" do
    scenario "question appears on another user's page", :js do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_link 'Ask question', href: new_question_path

        fill_in 'Title', with: 'Test question'
        fill_in 'Text', with: 'test text'
        click_on 'Create'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end