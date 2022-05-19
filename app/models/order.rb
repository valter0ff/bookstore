# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM

  STATES = {
    in_progress: 0,
    in_queue: 1,
    in_delivery: 2,
    delivered: 3,
    canceled: 4
  }.freeze

  belongs_to :user_account, optional: true
  belongs_to :coupon, optional: true

  has_many :cart_items, dependent: :destroy

  enum state: STATES

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
      transitions from: [:in_progress, :in_queue, :in_delivery, :delivered], to: :canceled
    end
  end
end
