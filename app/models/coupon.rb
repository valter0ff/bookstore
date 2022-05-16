# frozen_string_literal: true

class Coupon < ApplicationRecord
  STATUSES = { active: 0, used: 1 }.freeze

  attribute :code, default: -> { SecureRandom.uuid }
  attribute :discount, default: Constants::Checkout::DEFAULT_DISCOUNT

  has_many :orders

  enum status: STATUSES

  validates_uniqueness_of :code
end
