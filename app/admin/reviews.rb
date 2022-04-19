# frozen_string_literal: true

ActiveAdmin.register Review do
  config.filters = false

  permit_params :title, :body, :status, :book_id, :user_account_id

  includes :book, :user_account
  
  actions :all, except: [:edit, :new, :create]
  
  scope :unprocessed
  scope :approved
  scope :rejected
  
  index do 
    selectable_column
    column :book
    column :title
    column 'Date', :created_at
    column :user_account
    column :status
    actions
  end

  member_action :approve, method: :put do
    resource.approved!
    redirect_to admin_reviews_path, notice: "Approved!"
  end
  
  member_action :reject, method: :put do
    resource.rejected!
    redirect_to admin_reviews_path, notice: "Rejected!"
  end
  
  action_item :approve, only: :show do
     link_to 'Approve', approve_admin_review_path(review), method: :put
  end
  
  action_item :reject, only: :show do
    link_to 'Reject', reject_admin_review_path(review), method: :put
  end
  
  show do
    default_main_content 
  end

end
 
