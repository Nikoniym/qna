require 'rails_helper'

feature 'Best answer for author question', %q{
  In order to set the best answer to the first place from community
  As an authenticated user
  I want to be able to choose the best answer for my question
} do
  given(:users) { create_list(:user, 2) }
  given(:question_1) { create(:question, user: users.first) }
  given(:question_2) { create(:question, user: users.last) }
  given!(:answers_1) { create_list(:answer_various, 3, user: users.first, question: question_1) }
  given!(:answers_2) { create_list(:answer_various, 3, user: users.last, question: question_2) }

  describe 'Authenticated user' do
    before { sign_in(users.first) }

    scenario 'Set best answer from my question', js: true do
      visit question_path(question_1)

      click_link 'best', href: set_best_answer_path(answers_1.last)

      expect(page).to have_content 'The answer was set best successfully'

      within all('.answer-item').last do
        expect(page).to_not have_content answers_1.last.body
      end

      within all('.answer-item').first do
        expect(page).to have_content answers_1.last.body
        expect(page).to have_content 'Marked by the Asker as the best'
        expect(page).to_not have_link 'best'
      end
    end

    scenario 'Set best answer for one answer', js: true do
      visit question_path(question_1)

      click_link 'best', href: set_best_answer_path(answers_1.last)

      answers_1.each do |answer|
        within (".answer-#{answer.id}") do
          if answer == answers_1.last
            expect(page).to have_content 'Marked by the Asker as the best'
          else
            expect(page).to_not have_content 'Marked by the Asker as the best'
          end
        end
      end
    end

    scenario "Don't show the link after you update the best answer", js: true do
      visit question_path(question_1)

      within (".answer-#{answers_1.first.id}") do
        click_link 'best'

        sleep(0.1)

        click_link 'edit'
        click_on 'Update'

        expect(page).to_not have_link 'best'
      end
    end

    scenario "Don't set best answer not for your question" do
      visit question_path(question_2)
      expect(page).to_not have_link 'best'
    end
  end

  scenario 'Unauthorized guest can not set best an answer' do
    visit question_path(question_1)

    expect(page).to_not have_link 'best'
  end
end