# frozen_string_literal: true

class ShippingMethod < ApplicationRecord
  has_many :orders, dependent: :nullify

  validates :name, presence: true
end
