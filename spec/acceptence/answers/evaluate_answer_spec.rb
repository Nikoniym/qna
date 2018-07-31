require 'rails_helper'

feature 'To evaluate the answer', %q{
  In order to rating the answer from community
  As an authenticated user
  I want to be able to evaluate the answer
} do
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer_1) { create(:answer, question: question, user: users.first) }
  given!(:answer_2) { create(:answer, question: question, user: users.last) }

  describe 'Authenticated user' do
    before do
      sign_in(users.first)
      visit question_path(question)
    end

    scenario 'set like not for your answer', js: true do
      within ".answer-#{answer_2.id}" do
        click_link 'like'
        expect(page).to have_content '1'
      end
      expect(page).to have_content 'This answer successfully like'
    end
    scenario 'set dislike not for your answer', js: true do
      within ".answer-#{answer_2.id}" do
        click_link 'dislike'
        expect(page).to have_content '-1'
      end
      expect(page).to have_content 'This answer successfully dislike'
    end

    scenario 'like twice', js: true do
      within ".answer-#{answer_2.id}" do
        click_link 'like'
        sleep(0.1)
        click_link 'like'
        expect(page).to have_content '1'
      end
      expect(page).to have_content 'You have already put a like on this answer'
    end

    scenario 'dislike twice', js: true do
      within ".answer-#{answer_2.id}" do
        click_link 'dislike'
        sleep(0.1)
        click_link 'dislike'
        expect(page).to have_content '-1'
      end
      expect(page).to have_content 'You have already put a dislike on this answer'
    end

    scenario 'you cannot vote for your answer' do
      within ".answer-#{answer_1.id}" do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to_not have_link 'cancel vote'
        expect(page).to have_content '0'
      end
    end

    scenario 'cancel vote after like', js: true do
      within ".answer-#{answer_2.id}" do
        click_link 'like'
        sleep(0.1)
        click_link 'cancel vote'
        expect(page).to have_content '0'
      end
      expect(page).to have_content 'Voting for the answer is canceled successfully'
    end

    scenario 'when there is nothing to cancel', json: true do
      within ".answer-#{answer_2.id}" do
        click_link 'cancel vote'
        expect(page).to have_content '0'
      end
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end

  scenario 'An unauthenticated user tries to vote on a answer', js: true do
    visit question_path(question)

    within ".answer-#{answer_1.id}" do
      click_link 'like'
      expect(page).to have_content '0'
    end
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end