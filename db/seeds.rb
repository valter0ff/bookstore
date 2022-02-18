# frozen_string_literal: true

ActiveRecord::Base.transaction do
  CATEGORIES = ['Mobile development', 'Photo', 'Web design', 'Web development']

  categories = CATEGORIES.map do |name|
                FactoryBot.create(:category, title: name)
               end
end
