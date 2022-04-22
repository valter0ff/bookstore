# frozen_string_literal: true

ActiveAdmin.register Category do
  permit_params :title

  index do
    selectable_column
    column :title
    actions
  end

  show do
    default_main_content
  end

  form do |f|
    f.inputs do
      f.input :title
    end
    f.actions
  end
end
