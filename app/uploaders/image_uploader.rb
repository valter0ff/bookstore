# frozen_string_literal: true

class ImageUploader < ApplicationUploader
  SMALL_VERSION = [50, 50].freeze
  MEDIUM_VERSION = [150, 150].freeze
  IMAGE_MAX_MB_SIZE = 10

  Attacher.validate do
    validate_extension Constants::Images::IMAGE_EXTENSIONS,
                       message: I18n.t('file.wrong_extension',
                                       list: Constants::Images::IMAGE_EXTENSIONS.join(', ').upcase)
    validate_mime_type Constants::Images::IMAGE_MIME_TYPES,
                       message: I18n.t('file.wrong_mime_type',
                                       list: Constants::Images::IMAGE_MIME_TYPES.join(', ').upcase)
    validate_max_size IMAGE_MAX_MB_SIZE.megabytes,
                      message: I18n.t('file.size_exceeded', size: IMAGE_MAX_MB_SIZE)
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      small: magick.resize_to_limit!(*SMALL_VERSION),
      medium: magick.resize_to_limit!(*MEDIUM_VERSION)
    }
  end
end
