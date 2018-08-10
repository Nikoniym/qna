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
    Subscription.find_by(user: user, question: self)
  end

  private

  def self.send_daily_digest
    @questions = Question.where('created_at >= ?', Time.zone.now.beginning_of_day)

    if @questions
      User.find_each do |user|
        DailyMailer.digest(user, @questions).deliver_now
      end
    end
  end

  def create_subscription
    Subscription.create(user_id: user_id, question: self)
  end
end
