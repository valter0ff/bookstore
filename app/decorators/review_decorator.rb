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

  def author_image
    user_avatar || avatar_placeholder
  end

  private

  def avatar_placeholder
    content_tag(:p, author[0].capitalize, class: 'img-circle logo-size inlide-block pull-left logo-empty')
  end

  def user_avatar
    return unless user_account.try(:picture)

    image_tag(user_account.picture.image_url(:small), class: 'img-circle logo-size inlide-block pull-left')
  end
end
