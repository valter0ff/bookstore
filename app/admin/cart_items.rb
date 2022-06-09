# frozen_string_literal: true

ActiveAdmin.register CartItem do
  permit_params :order_id, :book_id, :books_count

  index do
    selectable_column
    column :id
    column :order_id
    column(:book) { |cart_item| Book.where(id: cart_item.book_id).pluck(:id, :title) }
    column :books_count
    actions
  end

  show do
    default_main_content do
      row :books_count
      row(:book) { |item| item.book.title }
    end
  end

  form do |f|
    f.inputs do
      f.input :order
      f.input :book
      f.input :books_count
    end
    f.actions
  end
end
