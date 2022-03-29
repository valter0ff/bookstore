# frozen_string_literal: true

module FlashMessagesHelper
  FLASH_CSS = {
    notice: 'alert-info',
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-danger'
  }.freeze

  def flash_class(level)
    FLASH_CSS[level.to_sym]
  end
end
