# frozen_string_literal: true

class UserAccount < ApplicationRecord
  PASSWORD_FORMAT = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])\S{8,}\z/.freeze
  EMAIL_LOCALPART = '\A(?!-)(?!\.)(?!.+--)(?!.+\.\.)([a-zA-Z0-9!#$%&\'.*+\-/=?^_`{|}~]){1,63}(?<!-)(?<!\.)'
  EMAIL_DOMENPART = '(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})'
  EMAIL_FORMAT = /#{EMAIL_LOCALPART}@#{EMAIL_DOMENPART}\z/.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
         :recoverable, :omniauthable

  validates :email, :password, presence: true
  validates :password, format: { with: PASSWORD_FORMAT, message: I18n.t('errors.messages.password_complexity') }
  validates :email, format: { with: EMAIL_FORMAT, message: I18n.t('errors.messages.email_format') }

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_message(self).deliver_now
  end
end
