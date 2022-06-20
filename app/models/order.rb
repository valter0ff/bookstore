# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM

  STATES = { in_progress: 0, in_queue: 1, in_delivery: 2, delivered: 3, canceled: 4 }.freeze
  STEPS = { address: 0, shipping: 1, payment: 2, confirm: 3, complete: 4 }.freeze

  belongs_to :user_account, optional: true
  belongs_to :coupon, optional: true
  belongs_to :shipping_method, optional: true

  has_many :cart_items, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  accepts_nested_attributes_for :credit_card, allow_destroy: true, update_only: true

  enum state: STATES
  enum step: STEPS

  aasm column: :state, enum: true, timestamps: true do
    state :in_progress, initial: true
    state :in_queue, :in_delivery, :delivered, :canceled

    event :get_payed do
      transitions from: :in_progress, to: :in_queue
    end

    event :send_to_client do
      transitions from: :in_queue, to: :in_delivery
    end

    event :complete do
      transitions from: :in_delivery, to: :delivered, if: :in_delivery?
    end

    event :cancel do
      transitions from: %i[in_progress in_queue in_delivery delivered], to: :canceled
    end
  end

#   aasm column: :step, enum: true do
#     step :address, initial: true
#     step :shipping, :payment, :confirm, :complete
#
#     event :to_shipping do
#       transitions from: :address, to: :shipping
#     end
#
#     event :to_payment do
#       transitions from: :shipping, to: :payment
#     end
#
#     event :to_confirm do
#       transitions from: :payment, to: :confirm
#     end
#
#     event :to_complete do
#       transitions from: :confirm, to: :complete
#     end
#   end
end
