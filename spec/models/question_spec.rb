require 'rails_helper'

RSpec.describe Question, type: :model do
  question = FactoryBot.build(:question)
  it { expect(question).to have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end

