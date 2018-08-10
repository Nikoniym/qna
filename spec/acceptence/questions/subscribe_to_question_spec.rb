require 'rails_helper'

feature 'Subscribe to question', %q{
  In order to subscribe or unsubscribe to question
  As an authenticated user
  I want to be able receive new answers to your questions by mail
} do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question1) { create(:question, user: user1) }
  let(:question2) { create(:question, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user2)
    end

    scenario 'Subscribe to question', :js do
      visit question_path(question1)

      click_on 'Subscribe'

      expect(page).to have_content 'Subscription was successfully created.'
    end

    scenario 'Subscribe to question', :js do
      visit question_path(question2)

      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscription was successfully destroyed.'
    end
  end

  scenario 'Unauthorized guest can not subscribe' do
    visit question_path(question1)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end