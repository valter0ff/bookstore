# frozen_string_literal: true

module Constants
  module CreditCard
    NUMBER_FORMAT = %r{\A\d+\z}.freeze
    HOLDER_NAME_FORMAT = %r{\A[A-Za-z ]+\z}.freeze
    EXPIRY_DATE_FORMAT = %r{\A(0[1-9]|1[0-2])\/?([0-9]{2})\z}.freeze
    CVV_CODE_FORMAT = %r{\A[0-9]{3,4}\z}.freeze
    HOLDER_NAME_MAX_SIZE = 50
    NUMBER_MIN_SIZE = 15
    NUMBER_MAX_SIZE = 16
  end
end
