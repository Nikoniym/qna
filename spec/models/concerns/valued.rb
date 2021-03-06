shared_examples_for 'valued' do

  it { should have_many(:ratings).dependent(:destroy) }

  let(:else_user) { create(:user) }

  it '#number' do
    expect(resource.number).to eq 0
  end

  describe '#set_like?' do
    it 'return false if the user voted for the object' do
      expect(resource.set_like?(else_user)).to eq false
    end

    it 'return true if the user did not vote for the object' do
      resource.set_like!(else_user)
      expect(resource.set_like?(else_user)).to eq true
    end
  end

  describe '#set_dislike?' do
    it 'return false if the user voted for the object' do
      expect(resource.set_dislike?(else_user)).to eq false
    end

    it 'return true if the user did not vote for the object' do
      resource.set_dislike!(else_user)
      expect(resource.set_dislike?(else_user)).to eq true
    end
  end

  describe '#set_like!' do
    it 'to return 1 after the vote first time' do
      resource.set_like!(else_user)
      expect(resource.number).to eq 1
    end

    it 'to return 1 after the vote after dislike' do
      resource.set_dislike!(else_user)
      resource.set_like!(else_user)
      expect(resource.number).to eq 1
    end
  end

  describe '#set_dislike!' do
    it 'to return -1 after the vote first time' do
      resource.set_dislike!(else_user)
      expect(resource.number).to eq -1
    end

    it 'to return -1 after the vote after like' do
      resource.set_dislike!(else_user)
      expect(resource.number).to eq -1
    end
  end

  describe '#delete_vote!' do
    it 'to return 0 after the abolition of like' do
      resource.set_like!(else_user)
      resource.delete_vote!(else_user)
      expect(resource.reload.number).to eq 0
    end

    it 'to return 0 after the abolition of dislike' do
      resource.set_dislike!(else_user)
      resource.delete_vote!(else_user)
      expect(resource.reload.number).to eq 0
    end
  end

  describe '#can_like?' do
    it 'return false when already voted like' do
      resource.set_like!(else_user)
      expect(resource.can_like?(else_user)).to eq false
    end

    it 'return false when not yet voted like' do
      expect(resource.can_like?(else_user)).to eq true
    end
  end

  describe '#can_dislike?' do
    it 'return false when not yet voted dislike' do
      resource.set_dislike!(else_user)
      expect(resource.can_dislike?(else_user)).to eq false
    end

    it 'return false when already voted like' do
      expect(resource.can_dislike?(else_user)).to eq true
    end
  end
end
