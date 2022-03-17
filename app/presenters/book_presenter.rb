# frozen_string_literal: true

class BookPresenter < BasePresenter
  DESCRIPTION_LEHGTH = 250
  CURRENCY = '€'
  CURRENCY_FORMAT = '%u %n'

  def average_rating
    reviews.average(:rating)
  end

  def price_with_currency
    view_object.number_to_currency(price, unit: CURRENCY, format: CURRENCY_FORMAT)
  end

  def all_authors
    authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
  end

  def all_materials
    materials.map(&:title).join(', ')
  end

  def dimensions
    I18n.t('books.book_page.dimensions', height: height, width: width, depth: depth)
  end

  def truncated_description
    return description if description.length < DESCRIPTION_LEHGTH

    view_object.truncate(description, length: DESCRIPTION_LEHGTH, omission: '...', separator: ' ') do
      view_object.link_to I18n.t('books.book_page.read_more'), '#', class: 'in-gold-500 ml-10 read-more'
    end
  end
end
