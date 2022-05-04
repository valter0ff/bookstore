# frozen_string_literal: true

ActiveRecord::Base.transaction do
  CATEGORIES = I18n.t('partials.header.categories').values
  materials = FactoryBot.create_list(:material, 4)
  authors = FactoryBot.create_list(:author, 20)
  categories = CATEGORIES.map do |name|
                FactoryBot.create(:category, title: name)
               end
  users = FactoryBot.create_list(:user_account, 10)
  books = 100.times.map do
    FactoryBot.create(:book,
                      category: categories.sample,
                      authors: authors.sample(2),
                      materials: materials.sample(2))
    end
  200.times { FactoryBot.create(:review, book: books.sample, user_account: users.sample) }
  FactoryBot.create(:admin_user, email: 'admin@example.com', password: 'password') if Rails.env.development?
end
