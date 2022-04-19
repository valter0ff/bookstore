# frozen_string_literal: true

module Constants
  module Review
    COMMON_REGEXP = /\A[a-zA-Z0-9!#$%&\'.*+\-\/=?^_`{|}~ ]*\z/.freeze
    TITLE_MAX_SIZE = 80
    BODY_MAX_SIZE = 500
  end
end 
