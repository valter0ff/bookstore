# frozen_string_literal: true

ActiveAdmin.register Review do
  permit_params :title, :body, :status, :book_id, :user_account_id

  includes :book, :user_account

  actions :all, except: %i[edit new create]

  scope I18n.t('reviews.admin.new'), :unprocessed
  scope :approved, group: :processed
  scope :rejected, group: :processed

  index do
    selectable_column
    column :book
    column :title
    column :rating
    column I18n.t('reviews.admin.date'), :created_at
    column :user_account
    tag_column :status
    actions
  end

  preserve_default_filters!
  filter :book_id, label: I18n.t('reviews.admin.book_id')

  member_action :approve, method: :put do
    resource.approved!
    redirect_to admin_reviews_path, notice: I18n.t('flash.actions.update.notice', resource_name: resource_class.to_s)
  end

  member_action :reject, method: :put do
    resource.rejected!
    redirect_to admin_reviews_path, notice: I18n.t('flash.actions.update.notice', resource_name: resource_class.to_s)
  end

  action_item :approve, only: :show do
    link_to I18n.t('reviews.admin.approve'), approve_admin_review_path(review), method: :put
  end

  action_item :reject, only: :show do
    link_to I18n.t('reviews.admin.reject'), reject_admin_review_path(review), method: :put
  end

  batch_action :destroy, confirm: I18n.t('active_admin.delete_confirmation') do |ids|
    Review.where(id: ids).destroy_all
    redirect_to admin_reviews_path, notice: I18n.t('active_admin.batch_actions.succesfully_destroyed',
                                                   count: ids.count,
                                                   model: resource_class.to_s.downcase,
                                                   plural_model: resource_class.to_s.pluralize.titleize.downcase)
  end

  batch_action :approve do |ids|
    Review.where(id: ids).each(&:approved!)
    redirect_to admin_reviews_path, notice: I18n.t('active_admin.batch_actions.succesfully_updated',
                                                   count: ids.count,
                                                   model: resource_class.to_s.downcase,
                                                   plural_model: resource_class.to_s.pluralize.titleize.downcase)
  end

  batch_action :reject do |ids|
    Review.where(id: ids).each(&:rejected!)
    redirect_to admin_reviews_path, notice: I18n.t('active_admin.batch_actions.succesfully_updated',
                                                   count: ids.count,
                                                   model: resource_class.to_s.downcase,
                                                   plural_model: resource_class.to_s.pluralize.titleize.downcase)
  end

  show do
    default_main_content
  end
end
