require 'rails_helper'

feature 'Show list questions', %q{
  In order to show all questions
  As an any user
  I want to be able index questions
} do


  given!(:questions) { create_list(:question_various, 2) }

  scenario 'View all questions on the page index' do
    visit '/questions'

    questions.each do |question|
      expect(page).to have_content(question.title, question.body)
    end
  end
end