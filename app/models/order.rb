# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM

  STATES = { in_cart: 0, in_progress: 1, in_queue: 2, in_delivery: 3, delivered: 4, canceled: 5 }.freeze
  STEPS = { address: 0, delivery: 1, payment: 2, confirm: 3, complete: 4 }.freeze

  belongs_to :user_account, optional: true
  belongs_to :coupon, optional: true
  belongs_to :shipping_method, optional: true

  has_many :cart_items, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  accepts_nested_attributes_for :credit_card, allow_destroy: true, update_only: true

  enum state: STATES
  enum step: STEPS

  aasm(:state, column: :state, enum: :states, timestamps: true) do
    state :in_cart, initial: true
    state :in_progress, :in_queue, :in_delivery, :delivered, :canceled

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

  aasm(:checkout_step, column: :step, enum: :steps) do
    state :address, initial: true
    state :delivery, :payment, :confirm, :complete

    event :to_delivery_step do
      transitions from: :address, to: :delivery
    end

    event :to_payment_step do
      transitions from: :delivery, to: :payment
    end

    event :to_confirm_step do
      transitions from: :payment, to: :confirm
    end

    event :to_complete_step do
      transitions from: :confirm, to: :complete
    end
  end

  def select_shipping_address
    user_account.use_billing_address ? user_account.billing_address : user_account.shipping_address
  end
end
