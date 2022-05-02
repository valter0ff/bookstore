# frozen_string_literal: true

ActiveAdmin.register UserAccount do
  decorate_with UserAccountDecorator

  permit_params :email, :password, :password_confirmation, picture_attributes: [:image, :id, :_destroy]

  includes :picture, :billing_address, :shipping_address

  index do
    selectable_column
    id_column
    column I18n.t('user_accounts.admin.avatar') do |user_account|
      image_tag user_account.picture.image_url, size: '100' if user_account.picture
    end
    column :email
    column I18n.t('user_accounts.admin.full_name') do |user_account|
      user_account.full_name
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do
    attributes_table do
      row(I18n.t('user_accounts.admin.avatar')) { image_tag user_account.picture.image_url, size: "100" }
      row :email
      row :remember_created_at
      row :created_at
      row :updated_at
    end
    panel I18n.t('addresses.new.shipping_title') do
      table_for user_account.shipping_address do
        column :first_name
        column :last_name
        column :city
        column :address
        column :country_name
        column :zip
        column :phone
      end
    end
    panel I18n.t('addresses.new.billing_title') do
      table_for user_account.billing_address do
        column :first_name
        column :last_name
        column :city
        column :address
        column :country_name
        column :zip
        column :phone
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password, required: f.object.new_record?
      f.input :password_confirmation, required: f.object.new_record?
      f.inputs I18n.t('users.admin.avatar'), for: [:picture, f.object.picture || Picture.new] do |p|
        p.input :image, as: :file, hint: ((image_tag p.object.image_url, size: '100') if p.object.image)
      end
    end
    f.actions
  end

  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end
end
