require 'rails_helper'

feature 'Destroy answer', %q{
  In order to destroy answer
  As an authenticated user
  I want to be able to destroy my answer
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users.first)}
  given!(:answer_1) { create(:answer_various, user: users.first, question: question ) }
  given!(:answer_2) { create(:answer_various, user: users.last, question: question) }

  scenario 'Authenticated user deletes his answer' do
    sign_in(users.first)
    visit question_path(question)

    click_link('destroy', href: answer_path(answer_1))

    expect(page).to have_content 'Your answer successfully destroy'
    expect(page).to_not have_content answer_1.body
  end

  scenario "Authenticated user can't destroy not his answer" do
    sign_in(users.first)
    visit question_path(question)

    expect(page).to_not have_link('destroy', href: answer_path(answer_2))
  end



  scenario 'Unauthorized guest can not destroy a answer' do
    visit question_path(question)

    expect(page).to_not have_link 'destroy'
  end
end