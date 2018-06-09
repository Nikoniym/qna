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

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'text text text'
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

  context "mulitple sessions" do
    scenario "question appears on another user's page", :js do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'text text text'

        click_link 'add file'
        attach_file "#{Rails.root}/spec/spec_helper.rb"

        click_on 'Create'

        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
        expect(page).to have_link 'spec_helper.rb'

        within('.answer-item') do
          click_link 'like'
        end

        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end