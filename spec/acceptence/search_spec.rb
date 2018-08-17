require 'rails_helper'

feature 'Searching','
  In order to show result searching
  As an any user
  I want to be able search the site
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user, title: 'MyText') }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  ['question', 'answer', 'comment'].each do |model|
    scenario "Try to find in #{model}", :js do

      ThinkingSphinx::Test.run do
        visit root_path

        fill_in 'text', with: 'MyText'
        find(:select, 'model').find(:option, model).select_option
        click_on 'Search'

        expect(current_path).to eq search_index_path
        expect(page).to have_content(model.capitalize)
        expect(page).to have_content('MyText')
      end
    end
  end

  scenario 'Try to find user', :js do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'text', with: user.email
      find(:select, 'model').find(:option, 'user').select_option
      click_on 'Search'

      expect(page).to have_content('User')
      expect(page).to have_content(user.email)
    end
  end

  scenario 'Try to find Everywhere', :js do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'text', with: user.email
      click_on 'Search'

      ['question', 'answer', 'comment'].each do |model|
        expect(page).to have_content(model.capitalize)
        expect(page).to have_content('MyText')
      end

      expect(page).to have_content('User')
      expect(page).to have_content(user.email)
    end
  end
end