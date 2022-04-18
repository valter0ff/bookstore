# frozen_string_literal: true

module Constants
  module Address
    COMMON_INFO_MAX_SIZE = 50
    ZIP_MAX_SIZE = 10
    PHONE_MAX_SIZE = 15
    INFORMATION_REGEXP = /\A[A-Za-z ]+\z/.freeze
    ADDRESS_REGEXP = /\A[A-Za-z0-9,'\-. ]+\z/.freeze
    ZIP_REGEXP = /\A[0-9\-]+\z/.freeze
    PHONE_REGEXP = /\A\+[0-9 ]+\z/.freeze
  end
end
