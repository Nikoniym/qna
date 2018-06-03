shared_examples_for "valuable" do
  describe '#put_like' do
   it 'not keep like to database for your resource' do
     expect { put :put_like, params: { id: resource }, format: :json }.to_not change(resource.rating.rating_users, :count)
   end

   it 'save to database for not your resource' do
     expect { put :put_like, params: { id: else_resource }, format: :json }.to change(else_resource.rating.rating_users, :count).by(1)
   end

   it 'double like' do
     put :put_like, params: { id: else_resource }, format: :json
     expect(put :put_like, params: { id: else_resource }, format: :json).to have_http_status(:unprocessable_entity)
   end
  end

  describe '#put_dislike' do
    it 'not keep dislike to database for your resource' do
      expect { put :put_dislike, params: { id: resource }, format: :json }.to_not change(resource.rating.rating_users, :count)
    end

    it 'save to database for not your resource' do
      expect { put :put_dislike, params: { id: else_resource }, format: :json }.to change(else_resource.rating.rating_users, :count).by(1)
    end

    it 'double dislike' do
      put :put_dislike, params: { id: else_resource }, format: :json
      expect(put :put_dislike, params: { id: else_resource }, format: :json).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#cancel_vote' do
    it 'not change to database for your resource' do
      expect { put :cancel_vote, params: { id: resource }, format: :json }.to_not change(resource.rating.rating_users, :count)
    end

    it 'change to database for not your resource' do
      put :put_dislike, params: { id: else_resource }, format: :json
      expect { put :cancel_vote, params: { id: else_resource }, format: :json }.to change(else_resource.rating.rating_users, :count).by(-1)
    end

    it 'nothing to cancel' do
      expect(put :cancel_vote, params: { id: else_resource }, format: :json).to have_http_status(:unprocessable_entity)
    end
  end

  it 'dislike after like' do
    put :put_like, params: { id: else_resource }, format: :json
    expect { put :put_dislike, params: { id: else_resource }, format: :json }.to_not change(else_resource.rating.rating_users, :count)
  end

  it 'like after dislike' do
    put :put_dislike, params: { id: else_resource }, format: :json
    expect { put :put_like, params: { id: else_resource }, format: :json }.to_not change(else_resource.rating.rating_users, :count)
  end
end