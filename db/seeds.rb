# frozen_string_literal: true

ActiveRecord::Base.transaction do
  CATEGORIES = I18n.t('partials.header.categories').values

  categories = CATEGORIES.map do |name|
                FactoryBot.create(:category, title: name)
               end
end
