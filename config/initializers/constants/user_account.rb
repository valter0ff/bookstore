# frozen_string_literal: true

module Constants
  module UserAccount
    PASSWORD_REGEXP = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])\S+\z/.freeze
    EMAIL_LOCALPART = '\A(?!-)(?!\.)(?!.+--)(?!.+\.\.)([a-zA-Z0-9!#$%&\'.*+\-\/=?^_`{|}~]){1,63}(?<!-)(?<!\.)'
    EMAIL_DOMENPART = '(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})'
    EMAIL_REGEXP = /#{EMAIL_LOCALPART}@#{EMAIL_DOMENPART}\z/.freeze
    PASSWORD_MIN_SIZE = 8
    PASSWORD_MAX_SIZE = 50
  end
end
