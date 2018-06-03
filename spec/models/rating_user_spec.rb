require 'rails_helper'

RSpec.describe RatingUser, type: :model do
  it { should belong_to :rating }
  it { should belong_to :user }
end
