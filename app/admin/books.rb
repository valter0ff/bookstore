# frozen_string_literal: true

include ActiveAdmin::BooksHelper

ActiveAdmin.register Book do
  DESCRIPTION_LENGTH = 250
  
  permit_params :title, :description, :year_publication, :height, :width, :depth, :price, :quantity, :category_id, author_ids: [], material_ids: []
  
  includes :category, [:authors], [:author_books]
  
  index do
    selectable_column
    column :image
    column :category, sortable: 'categories.title'
    column :title
    column(:authors) { |book| clickable_authors(book) }
    column I18n.t('active_admin.books.short_description') do |book|
      truncate(book.description, length: DESCRIPTION_LENGTH)
    end
    column :price
    actions name: :actions, defaults: false do |book|
      item :View, edit_admin_book_path(book), class: 'member_link'
      item :Delete, admin_book_path(book), method: :delete,
        data: { confirm: I18n.t('active_admin.delete_confirmation') }
    end
  end
  
  filter :materials, as: :check_boxes
  filter :category
  filter :price

  show do
    default_main_content do
      row(:materials) { |book|  book.materials.map(&:title) }
      row(:authors) { |book| clickable_authors(book) }
    end
  end

  form do |f|
    f.inputs do 
      f.input :category, as: :select, prompt: I18n.t('active_admin.books.category_prompt')
      f.input :authors, as: :select, member_label: proc { |a| "#{a.first_name} #{a.last_name}" }
      f.input :materials, as: :check_boxes
      f.input :title
      f.input :description, as: :text
      f.input :year_publication
      f.input :height
      f.input :width
      f.input :depth
      f.input :price
      f.input :quantity
    end 
    f.actions 
  end
end

