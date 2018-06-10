shared_examples_for 'commented' do
  it { should have_many(:comments).dependent(:destroy) }
end