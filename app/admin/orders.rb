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
    column :shipping_method_id
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

  member_action :get_payed, method: :put do
    resource.get_payed!
    redirect_to resource_path
  end

  action_item :get_payed, only: :show, if: proc { resource.may_get_payed? } do
    button_to 'Get Payed', get_payed_admin_order_path(resource), method: :put
  end
end
