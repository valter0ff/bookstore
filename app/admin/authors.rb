# frozen_string_literal: true

ActiveAdmin.register Author do
  config.filters = false

  permit_params :first_name, :last_name, :description

  index do
    selectable_column
    column :first_name
    column :last_name
    column :description
    actions
  end

  show do
    default_main_content
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :description
    end
    f.actions
  end
end
