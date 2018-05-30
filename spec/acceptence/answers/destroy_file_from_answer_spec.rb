require 'rails_helper'


feature 'Destroy files to answer', %q{
  In order to delete my answer
  As an answer's author
  I want to be able to destroy file from your answer
} do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users.first)}
  given!(:answer_1) { create(:answer_various, user: users.first, question: question ) }
  given!(:answer_2) { create(:answer_various, user: users.last, question: question) }
  given!(:attachment_1) { create(:attachment, attachable: answer_1) }
  given!(:attachment_2) { create(:attachment, attachable: answer_2) }

  describe 'Authenticated user' do
    background do
      sign_in(users.first)
      visit question_path(question)
    end

    scenario 'Deletes file from his answer', js: true do
      within ".answer-#{answer_1.id}" do
        file_name = attachment_1.file.filename

        click_link 'delete', href: attachment_path(attachment_1)

        expect(page).to_not have_link 'delete'
        expect(page).to_not have_link file_name
      end
      expect(page).to have_content 'Your attachment successfully destroy'
    end

    scenario "You cannot delete a file from someone else's answer" do
      within ".answer-#{answer_2.id}" do
        expect(page).to_not have_link 'delete'
        expect(page).to have_link attachment_2.file.filename
      end
    end
  end


  scenario 'Unauthorized guest can not destroy file from the answer' do
    visit question_path(question)
    expect(page).to_not have_link 'delete'
  end
end