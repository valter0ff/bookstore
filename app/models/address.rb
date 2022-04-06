# frozen_string_literal: true

class Address < ApplicationRecord
  MAX_INFORMATION_LENGTH = 50
  MAX_ZIP_LENGTH = 10
  PHONE_MAX_LENGTH = 15
  INFORMATION_FORMAT = /\A[A-Za-z ]+\z/.freeze
  ADDRESS_FORMAT = /\A[A-Za-z0-9,\-. ]+\z/.freeze
  ZIP_FORMAT = /\A[0-9\-]+\z/.freeze
  PHONE_FORMAT = /\A\+[0-9 ]+\z/.freeze
  ERROR_ONLY_LETTERS = I18n.t('addresses.errors.only_letters')
  ERROR_ADDRESS = I18n.t('addresses.errors.address')
  ERROR_ZIP = I18n.t('addresses.errors.zip')
  ERROR_PHONE = I18n.t('addresses.errors.phone')

  belongs_to :user_account

  validates :type, presence: true
  validates :first_name, :last_name, presence: true,
                                     length: { maximum: MAX_INFORMATION_LENGTH },
                                     format: { with: INFORMATION_FORMAT, message: ERROR_ONLY_LETTERS }
  validates :city, :country_code, presence: true,
                                  length: { maximum: MAX_INFORMATION_LENGTH },
                                  format: { with: INFORMATION_FORMAT, message: ERROR_ONLY_LETTERS }
  validates :address, presence: true,
                    length: { maximum: MAX_INFORMATION_LENGTH },
                    format: { with: ADDRESS_FORMAT, message: ERROR_ADDRESS } 
  validates :zip, presence: true, length: { maximum: MAX_ZIP_LENGTH },
                  format: { with: ZIP_FORMAT, message: ERROR_ZIP }
  validates :phone, presence: true, length: { maximum: PHONE_MAX_LENGTH },
                    format: { with: PHONE_FORMAT, message: ERROR_PHONE }
  
  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
  end
end
