class ShowAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :created_at, :updated_at

  has_many :comments
  has_many :attachments
end
