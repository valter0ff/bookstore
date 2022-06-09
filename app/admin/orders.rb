# frozen_string_literal: true

ActiveAdmin.register Order do
  permit_params :number, :user_account_id, :coupon_id, :state
  decorate_with OrderDecorator

  includes :cart_items

  scope :all, default: true
  scope :in_progress
  scope :in_queue
  scope :in_delivery
  scope :delivered
  scope :canceled

  index do
    selectable_column
    column :id
    column :number
    column :user_account_id
    column :coupon_id
    column :cart_items do |order|
      order.cart_items.map(&:book_id_with_count)
    end
    column :created_at
    tag_column :state
    actions
  end

  show do
    default_main_content
  end
end
