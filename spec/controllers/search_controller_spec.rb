require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    %w(all user question answer comment).each do |model|
      it "with model #{model.capitalize}" do
        get :index, params: { text: 'text text text', model: model }
        expect(response).to render_template :index
      end
    end

    it 'with blank text' do
      get :index, params: { text: '', model: 'all' }
      expect(response).to redirect_to root_path
    end
  end
end