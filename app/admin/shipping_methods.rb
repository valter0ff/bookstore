# frozen_string_literal: true

ActiveAdmin.register ShippingMethod do
  permit_params :name, :days, :price

  index do
    selectable_column
    column :id
    column :name
    column :days
    column :price
    actions
  end

  show do
    default_main_content
  end
end
