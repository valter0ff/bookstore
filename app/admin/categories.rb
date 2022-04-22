# frozen_string_literal: true

ActiveAdmin.register Category do
  config.filters = false

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

  batch_action :destroy, confirm: I18n.t('active_admin.delete_confirmation') do |ids|
    Category.where(id: ids).includes([:books]).destroy_all
    redirect_to admin_categories_path, notice: I18n.t('active_admin.batch_actions.succesfully_destroyed',
                                                      count: ids.count,
                                                      model: resource_class.to_s.downcase,
                                                      plural_model: resource_class.to_s.pluralize.titleize.downcase)
  end
end
