class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :confirmable, omniauth_providers: %i[facebook twitter]

  has_many :questions
  has_many :answers
  has_many :ratings
  has_many :authorizations, dependent: :destroy
  has_many :comments
  has_many :subscriptions, dependent: :destroy

  def author_of?(object)
    object.user_id == id
  end

  def self.find_for_ouath(auth)
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    return authorization.user if authorization

    email = auth['info']['email']

    user = User.find_by_email(email)

    unless user
      password = Devise.friendly_token
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save
    end

    user.authorizations.create(provider:auth['provider'], uid: auth['uid'].to_s) if user.persisted?
    user
  end

  def self.send_daily_digest
    questions = Question.where('created_at >= ?', Time.zone.now.beginning_of_day)

    if questions.present?
      hash_question = []
      questions.each { |q| hash_question << q }

      find_each do |user|
        DailyMailer.digest(user, hash_question).deliver_later
      end
    end
  end
end
