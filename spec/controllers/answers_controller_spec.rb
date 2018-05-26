require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question,  user: @user) }
  let!(:answer) { create(:answer, question: question, user: @user)}

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assings the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render to template create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end

      it 'connection with a logged in user after saving' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer).user).to eq @user
      end

      it 'view the flash message' do
        post :create, params: { question_id: question, answer: attributes_for(:answer)}, format: :js
        expect(flash[:notice]).to eq 'Your answer successfully created'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer)}, format: :js  }.to_not change(Answer, :count)
      end

      it 'render to template create' do
        post :create,  params: { question_id: question, answer: attributes_for(:invalid_question) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assings the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end

      it 'view the flash message' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(flash[:notice]).to eq 'Your answer successfully update'
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer, answer: { body: '' } }, format: :js }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end

    context 'not author of the answer' do
      let(:answer) { create(:answer, question: question, user: create(:user))}

      it 'cannot update answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(answer.body).to_not eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end

      it 'view the flash message' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(flash[:alert]).to eq "You can't update someone else's answer"
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author of the answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id:  answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end

      it 'view the flash message' do
        delete :destroy, params: { id: answer }, format: :js
        expect(flash[:notice]).to eq 'Your answer successfully destroy'
      end
    end

    context 'not author of the answer' do
      let(:answer) { create(:answer, question: question, user: create(:user))}

      it 'cannot delete answer' do
        expect { delete :destroy, params: { id:  answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end

      it 'view the flash message' do
        delete :destroy, params: { id: answer }, format: :js
        expect(flash[:alert]).to eq "You can't delete someone else's answer"
      end
    end
  end
end
