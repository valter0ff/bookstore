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
                       unless: :attributes_updated?

  has_one :shipping_address, dependent: :destroy
  has_one :billing_address, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :picture, as: :imageable, dependent: :destroy

  after_create :send_welcome_email

  accepts_nested_attributes_for :picture, allow_destroy: true

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

  def attributes_updated?
    (email_changed? && persisted?) || picture.changed?
  end

  def send_welcome_email
    UserMailer.welcome_message(self).deliver_now
  end
end
