require 'rails_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer with valid parameter', js: true do
    fill_in 'Body', with: 'text text text'
    click_link 'add file'
    click_link 'add file'
    inputs_list = find('#new_answer').all("input[type='file']")
    inputs_list.first.set("#{Rails.root}/spec/spec_helper.rb")
    inputs_list.last.set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Create'

    within '.answers-list' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end
end