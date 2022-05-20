# frozen_string_literal: true

class Coupon < ApplicationRecord
  STATUSES = { active: 0, used: 1 }.freeze

  attribute :code, default: -> { SecureRandom.uuid }
  attribute :discount, default: Constants::Checkout::DEFAULT_DISCOUNT

  has_many :orders, dependent: nil

  enum status: STATUSES

  validates :code, uniqueness: true
end
