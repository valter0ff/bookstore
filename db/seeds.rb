# frozen_string_literal: true

ActiveRecord::Base.transaction do
  CATEGORIES = I18n.t('partials.header.categories').values

  categories = CATEGORIES.map do |name|
                FactoryBot.create(:category, title: name)
               end
  60.times do
    FactoryBot.create(:book, #:book_with_reviews,
                      category: Category.all.sample)
#                       category: categories.sample,
#                     authors: authors.sample(2),
#                     materials: materials.sample(2))
    end
end
