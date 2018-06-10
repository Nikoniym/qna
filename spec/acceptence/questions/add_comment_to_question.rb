require 'rails_helper'

feature 'Add comment to question', %q{
  In order to get comment from community
   As an authenticated user
  I want to be able to leave comments
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create comment with valid parameter', :js do
      within('.question-comments-list') do
        click_on 'add comment'
        fill_in 'Body', with: 'text text text'
        click_on 'Comment'

        expect(page).to have_content 'text text text'
      end
      expect(page).to have_content 'Your comment successfully created'
    end

    scenario 'create comment with invalid parameter', :js do
      within('.question-comments-list') do
        click_on 'add comment'
        fill_in 'Body', with: ''
        click_on 'Comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'non-authenticated user tries to leave a comment', :js do
    visit question_path(question)

    click_on 'add comment'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context "mulitple sessions" do
    scenario "comment appears on another user's page", :js do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.question-comments-list') do
          click_on 'add comment'
          fill_in 'Body', with: 'text text text'
          click_on 'Comment'

          expect(page).to have_content 'text text text'
        end
        expect(page).to have_content 'Your comment successfully created'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end
end
