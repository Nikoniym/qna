require 'rails_helper'


feature 'Destroy files to question', %q{
  In order to delete my question
  As an question's author
  I want to be able to destroy file from your question
} do

  given(:users) { create_list(:user, 2) }
  given(:question_1) { create(:question_various, user: users.first) }
  given(:question_2) { create(:question_various, user: users.last) }
  given!(:attachment_1) { create(:attachment, attachable: question_1) }
  given!(:attachment_2) { create(:attachment, attachable: question_2) }

  describe 'Authenticated user' do
    background do
      sign_in(users.first)
    end

    scenario 'Deletes file from his question', js: true do
      visit question_path(question_1)

      file_name = attachment_1.file.filename

      click_link 'delete', href: attachment_path(attachment_1)

      expect(page).to_not have_link 'delete'
      expect(page).to_not have_link file_name
      expect(page).to have_content 'Your attachment successfully destroy'
    end

    scenario "You cannot delete a file from someone else's question" do
      visit question_path(question_2)

      expect(page).to_not have_link 'delete'
      expect(page).to have_link attachment_2.file.filename
    end
  end


  scenario 'Unauthorized guest can not destroy file from the answer' do
    visit question_path(question_1)

    expect(page).to_not have_link 'delete'
  end
end