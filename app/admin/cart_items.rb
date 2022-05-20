# frozen_string_literal: true

ActiveAdmin.register CartItem do
  permit_params :order_id, :book_id

  index do
    selectable_column
    column :order_id
    column(:book) { |cart_item| Book.where(id: cart_item.book_id).pluck(:id, :title) }
    column :books_count
    actions
  end

  show do
    default_main_content
  end
end
