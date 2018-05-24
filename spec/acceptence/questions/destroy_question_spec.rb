require 'rails_helper'

feature 'Destroy question', %q{
  In order to destroy question
  As an authenticated user
  I want to be able to destroy my question
} do

  given(:users) { create_list(:user, 2) }
  given(:question_1) { create(:question_various, user: users.first) }
  given(:question_2) { create(:question_various, user: users.last) }

  scenario 'Authenticated user deletes his question' do
    sign_in(users.first)
    visit question_path(question_1)

    click_on 'destroy'

    expect(page).to have_content 'Your question successfully destroy'
    expect(page).to_not have_content question_1.title
    expect(page).to_not have_content question_1.body
  end

  scenario "Authenticated user can't destroy not his question" do
    sign_in(users.first)
    visit question_path(question_2)

    expect(page).to_not have_link 'destroy'
  end



  scenario 'Unauthorized guest can not destroy a question' do
    visit question_path(question_1)

    expect(page).to_not have_link 'destroy'
  end
end