class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: %i[facebook]

  has_many :questions
  has_many :answers
  has_many :ratings
  has_many :authorizations

  def author_of?(object)
    object.user_id == id
  end

  def self.find_for_ouath(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    email = auth.uid.to_s + '@gmail.com' unless email

    user = User.find_by_email(email)

    unless user
      password = Devise.friendly_token
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
    user
  end
end
