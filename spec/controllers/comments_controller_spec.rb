require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user ) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new comment in the database' do
        expect { post :create, params: { comment: { body: 'text text text', commentable_id: question, commentable_type: 'Question'} }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'render to template create' do
        post :create, params: { comment: { body: 'text text text', commentable_id: question, commentable_type: 'Question'} }, format: :js
        expect(response).to render_template :create
      end

      it 'connection with a logged in user after saving' do
        post :create, params: { comment: { body: 'text text text', commentable_id: question, commentable_type: 'Question'} }, format: :js
        expect(assigns(:comment).user).to eq @user
      end

      it 'view the flash message' do
        post :create, params: { comment: { body: 'text text text', commentable_id: question, commentable_type: 'Question'} }, format: :js
        expect(flash[:notice]).to eq 'Your comment successfully created'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create, params: { comment: { body: '' } }, format: :js }.to_not change(Comment, :count)
      end

      it 'render to template create' do
        post :create, params: { comment: { body: ''} }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
