# frozen_string_literal: true

ActiveAdmin.register Review do
  config.filters = false

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
    column I18n.t('reviews.admin.date'), :created_at
    column :user_account
    tag_column :status
    actions
  end

  member_action :approve, method: :put do
    resource.approved!
    redirect_to admin_reviews_path, notice: I18n.t('reviews.admin.approved')
  end

  member_action :reject, method: :put do
    resource.rejected!
    redirect_to admin_reviews_path, notice: I18n.t('reviews.admin.rejected')
  end

  action_item :approve, only: :show do
    link_to I18n.t('reviews.admin.approve'), approve_admin_review_path(review), method: :put
  end

  action_item :reject, only: :show do
    link_to I18n.t('reviews.admin.reject'), reject_admin_review_path(review), method: :put
  end

  show do
    default_main_content
  end
end
