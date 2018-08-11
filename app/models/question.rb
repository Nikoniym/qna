class Question < ApplicationRecord
  include Valuable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  belongs_to :user
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  after_create :create_subscription

  def subscribe?(user)
    subscriptions.find_by(user: user)
  end

  private

  def create_subscription
    subscriptions.create(user_id: user_id)
  end
end
