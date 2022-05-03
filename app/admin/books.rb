# frozen_string_literal: true

ActiveAdmin.register Book do
  config.filters = false
  decorate_with BookDecorator

  permit_params :title, :description, :year_publication, :height, :width, :depth, :price, :quantity, :category_id,
                pictures_attributes: %i[image id _destroy], author_ids: [], material_ids: []

  includes :category, [:authors], [:author_books], [:pictures]

  index do
    selectable_column
    column(:pictures) { |book| book.pictures.map { |pic| image_tag pic.image_url, size: '100' } }
    column :category, sortable: 'categories.title'
    column :title
    column :authors, &:clickable_authors
    column I18n.t('books.admin.short_description'), &:short_description
    column :price
    actions
  end

  show do
    default_main_content do
      row :materials, &:all_materials
      row :authors, &:clickable_authors
      row :pictures do
        div style: 'display: flex' do
          book.pictures.each do |picture|
            div { image_tag picture.image_url, size: '200' }
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :category, as: :select, prompt: I18n.t('books.admin.category_prompt')
      f.input :authors,
              multiple: true,
              collection: Author.all.decorate.map { |author| [author.full_name, author.id] }
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
    f.inputs I18n.t('books.admin.pictures') do
      f.has_many :pictures, allow_destroy: true do |p|
        p.input :image, as: :file, hint: ((image_tag p.object.image_url, size: '100') if p.object.image)
      end
    end
    f.actions
  end
end
