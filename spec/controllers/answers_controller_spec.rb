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
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

      it 'view the flash message' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(flash[:notice]).to eq 'Your answer successfully created.'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 'render to template create' do
        post :create,  params: { question_id: question, answer: attributes_for(:invalid_question), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assings the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to the updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer, answer: { body: '' } } }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author of the answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id:  answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end

      it 'view the flash message' do
        delete :destroy, params: { id: answer }
        expect(flash[:notice]).to eq 'Your answer successfully destroy'
      end
    end

    context 'not author of the answer' do
      let(:answer) { create(:answer, question: question, user: create(:user))}

      it 'cannot delete answer' do
        expect { delete :destroy, params: { id:  answer } }.to_not change(Answer, :count)
      end

      it 'redirect to question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end

      it 'view the flash message' do
        delete :destroy, params: { id: answer }
        expect(flash[:alert]).to eq "You can't delete someone else's answer"
      end
    end
  end
end
