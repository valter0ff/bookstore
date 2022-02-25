# frozen_string_literal: true

class AuthorPresenter < BasePresenter
  def full_name
    "#{first_name} #{last_name}"
  end
end
