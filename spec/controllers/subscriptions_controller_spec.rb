require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question }, format: :js  }

    it 'create a subscription for user' do
      expect { post_create }.to change(@user.subscriptions, :count).by(1)
    end

    it 'create a subscription for question' do
      expect { post_create }.to change(question.subscriptions, :count).by(1)
    end

    it 'render template create' do
      post_create
      expect(response).to render_template :create
    end
  end

  describe 'POST #destroy' do
    let!(:subscription) { create(:subscription, user: @user, question: question) }
    let(:delete_destroy) { delete :destroy, params: { id: subscription.id }, format: :js  }

    it 'destroy subscription' do
      expect { delete_destroy }.to change(Subscription, :count).by(-1)
    end

    it 'render template create' do
      delete_destroy
      expect(response).to render_template :destroy
    end
  end
end