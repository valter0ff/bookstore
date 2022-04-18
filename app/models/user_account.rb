# frozen_string_literal: true

class UserAccount < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable,
         :recoverable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  validates :email, presence: true, on: :create
  validates :email, format: { with: Constants::UserAccount::EMAIL_REGEXP }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: Constants::UserAccount::PASSWORD_MIN_SIZE,
                                 maximum: Constants::UserAccount::PASSWORD_MAX_SIZE },
                       format: { with: Constants::UserAccount::PASSWORD_REGEXP },
                       unless: :email_updated?

  has_one :shipping_address, dependent: :destroy
  has_one :billing_address, dependent: :destroy

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

  def email_updated?
    email_changed? && persisted?
  end

  def send_welcome_email
    UserMailer.welcome_message(self).deliver_now
  end
end
