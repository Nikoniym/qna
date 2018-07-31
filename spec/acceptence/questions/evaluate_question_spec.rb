require 'rails_helper'

feature 'To evaluate the question', %q{
  In order to rating the question from community
  As an authenticated user
  I want to be able to evaluate the question
} do
  given(:users) { create_list(:user, 2) }
  given(:question_1) { create(:question_various, user: users.first) }
  given(:question_2) { create(:question_various, user: users.last) }

  describe 'Authenticated user' do
    before do
      sign_in(users.first)
    end

    scenario 'set like not for your question', js: true do
      visit question_path(question_2)

      within ".question-#{question_2.id}" do
        click_link 'like'
        expect(page).to have_content '1'
      end
      expect(page).to have_content 'This question successfully like'
    end
    scenario 'set dislike not for your question', js: true do
      visit question_path(question_2)

      within ".question-#{question_2.id}" do
        click_link 'dislike'
        expect(page).to have_content '-1'
      end
      expect(page).to have_content 'This question successfully dislike'
    end

    scenario 'like twice', js: true do
      visit question_path(question_2)

      within ".question-#{question_2.id}" do
        click_link 'like'
        sleep(0.1)
        click_link 'like'
        expect(page).to have_content '1'
      end
      expect(page).to have_content 'You have already put a like on this question'
    end

    scenario 'dislike twice', js: true do
      visit question_path(question_2)

      within ".question-#{question_2.id}" do
        click_link 'dislike'
        sleep(0.1)
        click_link 'dislike'
        expect(page).to have_content '-1'
      end
      expect(page).to have_content 'You have already put a dislike on this question'
    end

    scenario 'you cannot vote for your question' do
      visit question_path(question_1)

      within ".question-#{question_1.id}" do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to_not have_link 'cancel vote'
        expect(page).to have_content '0'
      end
    end

    scenario 'cancel vote after like', js: true do
      visit question_path(question_2)

      within ".question-#{question_2.id}" do
        click_link 'like'
        sleep(0.1)
        click_link 'cancel vote'
        expect(page).to have_content '0'
      end
      expect(page).to have_content 'Voting for the question is canceled successfully'
    end

    scenario 'when there is nothing to cancel', json: true do
      visit question_path(question_2)

      within ".question-#{question_2.id}" do
        click_link 'cancel vote'
        expect(page).to have_content '0'
      end
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end

  scenario 'An unauthenticated user tries to vote on a question', js: true do
    visit question_path(question_1)

    within ".question-#{question_1.id}" do
      click_link 'like'
      expect(page).to have_content '0'
    end
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end