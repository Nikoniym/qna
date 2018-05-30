FactoryBot.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'factories', 'attachments.rb')) }
  end
end
