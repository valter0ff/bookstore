# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  included do
    include ImageUploader::Attachment(:image)
  end

  def image_urls
    return {} unless image

    derivatives = image_derivatives.keys.map do |version|
      [version, image_derivatives[version].url]
    end

    [*derivatives, [:original, image.url]].to_h
  end
end
