# frozen_string_literal: true

class BookDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
  delegate_all
  decorates_association :author 
  
  def clickable_authors
    authors.map { |author| link_to author.decorate.full_name, admin_author_path(author) }
  end 
  
  def short_description
    truncate(description, length: Constants::Book::DESCRIPTION_LENGTH)
  end
end
