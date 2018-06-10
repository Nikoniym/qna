class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true

  belongs_to :user

  validates :body, presence: true

  default_scope { order(created_at: :asc) }
end
