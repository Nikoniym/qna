require 'rails_helper'

feature 'Show questions with answers', %q{
  In order to show page questions with answers from all users
  As an any user
  I want to be able to go from the list to the questions and view it along with the answers
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer_various, 2, question: question, user: user) }

  scenario 'go from the list to the questions' do

    visit '/questions'
    click_on 'show'
    expect(current_path).to eq question_path(question)
    # save_and_open_page
  end

  scenario 'have a questions with answers' do
    visit "/questions/#{question.id}"
    expect(page).to have_content(question.title, question.body)

    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end