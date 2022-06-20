# frozen_string_literal: true

class CreditCard < ApplicationRecord
  belongs_to :order

  validates :number, presence: true,
                     format: { with: Constants::CreditCard::NUMBER_FORMAT },
                     length: { minimum: Constants::CreditCard::NUMBER_MIN_SIZE,
                               maximum: Constants::CreditCard::NUMBER_MAX_SIZE }
  validates :holder_name, presence: true,
                          format: { with: Constants::CreditCard::HOLDER_NAME_FORMAT },
                          length: { maximum: Constants::CreditCard::HOLDER_NAME_MAX_SIZE }
  validates :expiry_date, presence: true,
                          format: { with: Constants::CreditCard::EXPIRY_DATE_FORMAT }
  validates :cvv_code, presence: true,
                       format: { with: Constants::CreditCard::CVV_CODE_FORMAT }
end
