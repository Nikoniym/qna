require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author of the attachable' do
      let(:question) { create(:question, user: @user) }
      let!(:attachment) { create(:attachment, attachable: question) }

      it 'delete attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js  }.to change(Attachment, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end

      it 'view the flash message' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(flash[:notice]).to eq 'Your attachment successfully destroy'
      end
    end

    context 'not author of the attachable' do
      let(:question) { create(:question, user: create(:user)) }
      let!(:attachment) { create(:attachment, attachable: question) }

      it 'cannot delete attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js  }.to_not change(Attachment, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to redirect_to root_url
      end

      it 'view the flash message' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(flash[:alert]).to eq 'You are not authorized to access this page.'
      end
    end
  end
end
