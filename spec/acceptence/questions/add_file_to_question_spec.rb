require 'rails_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question with valid parameter', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_link 'add file'
    click_link 'add file'
    inputs_list = find('#new_question').all("input[type='file']")
    inputs_list.first.set("#{Rails.root}/spec/spec_helper.rb")
    inputs_list.last.set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end