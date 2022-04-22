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

  batch_action :destroy, confirm: I18n.t('active_admin.delete_confirmation') do |ids|
    Author.where(id: ids).includes([:author_books]).destroy_all
    redirect_to admin_authors_path, notice: I18n.t('active_admin.batch_actions.succesfully_destroyed',
                                                   count: ids.count,
                                                   model: resource_class.to_s.downcase,
                                                   plural_model: resource_class.to_s.pluralize.titleize.downcase)
  end
end
