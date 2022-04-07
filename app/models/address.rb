# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user_account

  validates :first_name, :last_name, presence: true,
              length: { maximum: Constants::Address::COMMON_INFO_MAX_SIZE },
              format: { with: Constants::Address::INFORMATION_REGEXP }
  validates :city, :country_code, presence: true,
              length: { maximum: Constants::Address::COMMON_INFO_MAX_SIZE },
              format: { with: Constants::Address::INFORMATION_REGEXP }
  validates :address, presence: true, 
              length: { maximum: Constants::Address::COMMON_INFO_MAX_SIZE },
              format: { with: Constants::Address::ADDRESS_REGEXP } 
  validates :zip, presence: true, 
              length: { maximum: Constants::Address::ZIP_MAX_SIZE },
              format: { with: Constants::Address::ZIP_REGEXP }
  validates :phone, presence: true, 
              length: { maximum: Constants::Address::PHONE_MAX_SIZE },  
              format: { with: Constants::Address::PHONE_REGEXP }
  validates :type, presence: true
  
  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
  end
end
