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
    actions defaults: true do |coupon|
      if coupon.active?
        link_to I18n.t('coupons.admin.deactivate'), deactivate_admin_coupon_path(coupon), method: :put
      end
    end
  end

  member_action :deactivate, method: :put do
    resource.used!
    redirect_to admin_coupons_path, notice: I18n.t('flash.actions.update.notice', resource_name: resource_class.to_s)
  end

  action_item :deactivate, only: :show do
    link_to I18n.t('coupons.admin.deactivate'), deactivate_admin_coupon_path(coupon), method: :put
  end

  batch_action :deactivate do |ids|
    Coupon.where(id: ids).each(&:used!)
    redirect_to admin_coupons_path, notice: I18n.t('active_admin.batch_actions.succesfully_updated',
                                                   count: ids.count,
                                                   model: resource_class.to_s.downcase,
                                                   plural_model: resource_class.to_s.pluralize.titleize.downcase)
  end

  show do
    default_main_content
  end
end
