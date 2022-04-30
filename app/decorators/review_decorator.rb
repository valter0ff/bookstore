# frozen_string_literal: true

class ReviewDecorator < ApplicationDecorator
  delegate_all

  decorates_association :user_account

  def author
    user_account.full_name.presence || user_account.email
  end

  def blank_stars
    Constants::Review::RATING_STARS_COUNT - rating
  end
end
