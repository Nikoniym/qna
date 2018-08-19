require 'rails_helper'

RSpec.describe UserDecorator do
  include Rails.application.routes.url_helpers

  let(:user) { create(:user) }
  let(:decorator) { UserDecorator.new(user) }
  let(:path) { "mailto:#{user.email}" }
  let(:text) { user.email }
  let(:span) { 'User: ' }

  it_behaves_like 'Search response'
end
