require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.call' do
    Search::ATTR.each do |attr|
      it "for category: #{attr}" do
        if attr == 'all'
          expect(ThinkingSphinx).to receive(:search).with('find text', page: 1, per_page: 50)
        else
          expect(attr.classify.constantize).to receive(:search).with('find text', page: 1, per_page: 50)
        end

        Search.new('find text', attr).call
      end
    end
  end
end