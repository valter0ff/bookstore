# frozen_string_literal: true

class BookDecorator < ApplicationDecorator
  delegate_all
  decorates_association :authors

  def price_with_currency
    super(price)
  end

  def average_rating
    reviews.average(:rating)
  end

  def all_authors
    authors.map(&:full_name).join(', ')
  end

  def clickable_authors
    authors.map { |author| link_to author.full_name, admin_author_path(author) }
  end

  def dimensions
    I18n.t('books.show.dimensions', height: height, width: width, depth: depth)
  end

  def truncated_description
    return description if description.length < Constants::Book::DESCRIPTION_LENGTH

    truncate(description, length: Constants::Book::DESCRIPTION_LENGTH, omission: '...', separator: ' ') do
      link_to I18n.t('books.show.read_more'), '#', class: 'in-gold-500 ml-10 read-more'
    end
  end

  def short_description
    truncate(description, length: Constants::Book::DESCRIPTION_LENGTH)
  end

  def all_materials
    materials.map(&:title)
  end

  def main_image
    return Constants::Book::MAIN_IMAGE_PLACEHOLDER if pictures.blank?

    pictures.first.image_url
  end

  def cover_image
    return Constants::Book::COVER_IMAGE_PLACEHOLDER if pictures.blank?

    pictures.first.image_url
  end
end
