# frozen_string_literal: true

ActiveRecord::Base.transaction do
  CATEGORIES = I18n.t('partials.header.categories').values
  
  materials = FactoryBot.create_list(:material, 4)
  authors = FactoryBot.create_list(:author, 10)
  categories = CATEGORIES.map do |name|
                FactoryBot.create(:category, title: name)
               end
  60.times do
    FactoryBot.create(:book_with_reviews,
                      category: categories.sample,
                      authors: authors.sample(2),
                      materials: materials.sample(2))
    end
end
