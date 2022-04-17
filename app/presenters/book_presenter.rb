# frozen_string_literal: true

class BookPresenter < BasePresenter
  def average_rating
    reviews.average(:rating)
  end

  def price_with_currency
    view_object.number_to_currency(price, unit: Constants::Book::CURRENCY, format: Constants::Book::CURRENCY_FORMAT)
  end

  def all_authors
    authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
  end

  def all_materials
    materials.map(&:title).join(', ')
  end

  def dimensions
    I18n.t('books.show.dimensions', height: height, width: width, depth: depth)
  end

  def truncated_description
    return description if description.length < Constants::Book::DESCRIPTION_LENGTH

    view_object.truncate(description, length: Constants::Book::DESCRIPTION_LENGTH, omission: '...', separator: ' ') do
      view_object.link_to I18n.t('books.show.read_more'), '#', class: 'in-gold-500 ml-10 read-more'
    end
  end
end
