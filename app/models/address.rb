class Address < ApplicationRecord
  MAX_INFORMATION_LENGTH = 50
  MAX_ZIP_LENGTH = 10
  PHONE_MAX_LENGTH = 15
  INFORMATION_FORMAT = /\A[A-Za-z ]+\z/.freeze
  ADDRESS_FORMAT = /\A[A-Za-z0-9,\-. ]+\z/.freeze
  ZIP_FORMAT = /\A[0-9\-]+\z/.freeze
  PHONE_FORMAT = /\A\+[0-9 ]+\z/.freeze

  belongs_to :user_account

  validates :user_account_id, :type, :first_name, :last_name, presence: true
  validates :address, :city, :country_code, :zip, :phone, presence: true
  validates :first_name, :last_name, length: { maximum: MAX_INFORMATION_LENGTH }
  validates :address, :city, :country_code, length: { maximum: MAX_INFORMATION_LENGTH }
  validates :zip, length: { maximum: MAX_ZIP_LENGTH }
  validates :phone, length: { maximum: PHONE_MAX_LENGTH }
  validates :first_name, :last_name, format: { with: INFORMATION_FORMAT, message: 'allows only letters' }
  validates :city, :country_code, format: { with: INFORMATION_FORMAT, message: 'allows only letters' }
  validates :address,
            format: { with: ADDRESS_FORMAT, message: 'allows only letters, numbers, hyphens, commas, spaces' }
  validates :zip, format: { with: ZIP_FORMAT, message: 'allows only numbers and hyphens' }
  validates :phone, format: { with: PHONE_FORMAT, message: 'should start with plus and contain only numbers' }
end
