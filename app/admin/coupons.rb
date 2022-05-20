# frozen_string_literal: true

ActiveAdmin.register Coupon do
  permit_params :code, :discount, :status

  scope :all, default: true
  scope :active
  scope :used

  index do
    selectable_column
    column :code
    column :discount
    tag_column :status
    actions
  end

  show do
    default_main_content
  end
end
