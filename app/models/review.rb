# frozen_string_literal: true

class Review < ApplicationRecord
  STATUSES = { unprocessed: 0, approved: 1, rejected: 2 }.freeze

  belongs_to :book
  belongs_to :user_account

  enum status: STATUSES

  validates :title, presence: true,
                    length: { maximum: Constants::Review::TITLE_MAX_SIZE },
                    format: { with: Constants::Review::COMMON_REGEXP }
  validates :body, presence: true,
                   length: { maximum: Constants::Review::BODY_MAX_SIZE },
                   format: { with: Constants::Review::COMMON_REGEXP }
end
