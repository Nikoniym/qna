require 'rails_helper'

feature 'Edit the answer', %q{
  In order to get answers to the questions from community
  As an authenticated user and author answer
  I want to be able to edit my answer
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

    scenario 'sees link to edit' do
      within '.answers-list' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'Authenticated user to edit the answer with valid parameter', js: true do
      within '.answers-list' do
        click_link('edit')
        fill_in 'Body', with: 'text text text'

        click_on 'Update'
        expect(page).to have_content 'text text text'
      end
      expect(page).to have_content 'Your answer successfully update'
    end

    scenario 'Authenticated user to edit the answer with invalid parameter', js: true do
      within '.answers-list' do
        click_link('edit')
        fill_in 'Body', with: ''

        click_on 'Update'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'Authenticated user to edit the answer without being the author', js: true do
      within ".answer-#{answer_2.id}" do
        expect(page).to_not have_link 'edit'
      end
    end
  end

  scenario 'Non-authenticated user try to edit the answer to the questions' do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end
end