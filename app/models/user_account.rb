# frozen_string_literal: true

class UserAccount < ApplicationRecord
  PASSWORD_FORMAT = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])\S{8,}\z/.freeze
  EMAIL_LOCALPART = '\A(?!-)(?!\.)(?!.+--)(?!.+\.\.)([a-zA-Z0-9!#$%&\'.*+\-/=?^_`{|}~]){1,63}(?<!-)(?<!\.)'
  EMAIL_DOMENPART = '(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})'
  EMAIL_FORMAT = /#{EMAIL_LOCALPART}@#{EMAIL_DOMENPART}\z/.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
         :recoverable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  validates :email, :password, presence: true
  validates :password, format: { with: PASSWORD_FORMAT, message: I18n.t('errors.messages.password_complexity') }
  validates :email, format: { with: EMAIL_FORMAT, message: I18n.t('errors.messages.email_format') }

  after_create :send_welcome_email

  def self.new_with_session(params, session)
    super.tap do |user|
      data = session['devise.facebook_data']
      user.email = data['email'] if (data && data['extra']['raw_info']) && user.email.blank?
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def send_welcome_email
    UserMailer.welcome_message(self).deliver_now
  end
end
