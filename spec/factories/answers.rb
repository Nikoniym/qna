FactoryBot.define do
  factory :answer do
    body "MyText"
  end

  factory :answer_various, class: 'Answer' do
    body
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
