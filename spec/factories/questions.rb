FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end
  sequence :body do |n|
    "Body#{n}"
  end

  factory :question do
    title 'MyString'
    body 'MyText'
  end

  factory :question_various, class: 'Question' do
    title
    body
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
