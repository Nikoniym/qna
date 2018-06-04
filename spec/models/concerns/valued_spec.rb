shared_examples_for 'valued' do

  it { should have_many(:ratings).dependent(:destroy) }

  it '#number' do
    expect(resource.number).to eq 0
  end

  describe 'Set rating' do
    let(:else_user) { create(:user) }

    it '#set_like?(user) false' do
      expect(resource.set_like?(else_user)).to eq false
    end

    it '#set_like?(user) true' do
      resource.set_like!(else_user)
      expect(resource.set_like?(else_user)).to eq true
    end

    it '#set_dislike?(user) false' do
      expect(resource.set_dislike?(else_user)).to eq false
    end

    it '#set_dislike?(user) true' do
      resource.set_dislike!(else_user)
      expect(resource.set_dislike?(else_user)).to eq true
    end

    it '#set_like!(else_user)' do
      resource.set_like!(else_user)
      expect(resource.number).to eq 1
    end

    it '#set_dislike!(user)' do
      resource.set_dislike!(else_user)
      expect(resource.number).to eq -1
    end

    it '#delete_vote!(user) for like' do
      resource.set_like!(else_user)
      resource.delete_vote!(else_user)
      expect(resource.reload.number).to eq 0
    end

    it '#delete_vote!(user) for dislike' do
      resource.set_dislike!(else_user)
      resource.delete_vote!(else_user)
      expect(resource.reload.number).to eq 0
    end

    it '#like?(user) false' do
      resource.set_like!(else_user)
      expect(resource.like?(else_user)).to eq false
    end

    it '#like?(user) true' do
      expect(resource.like?(else_user)).to eq true
    end
    it '#like?(user) author false' do
      expect(resource.like?(user)).to eq false
    end

    it '#dislike?(user) false' do
      resource.set_dislike!(else_user)
      expect(resource.dislike?(else_user)).to eq false
    end

    it '#dislike?(user) author false' do
      expect(resource.dislike?(user)).to eq false
    end

    it '#dislike?(user) true' do
      expect(resource.dislike?(else_user)).to eq true
    end

    it '#cancel_vote?(user) false' do
      expect(resource.cancel_vote?(else_user)).to eq false
    end

    it '#cancel_vote?(user) false' do
      expect(resource.cancel_vote?(else_user)).to eq false
    end

    it '#cancel_vote?(user) author false' do
      expect(resource.cancel_vote?(user)).to eq false
    end

    it '#cancel_vote?(user) true' do
      resource.set_dislike!(else_user)
      expect(resource.cancel_vote?(else_user)).to eq true
    end
  end
end
