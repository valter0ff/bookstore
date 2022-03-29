# frozen_string_literal: true

module FlashMessagesHelper
  FLASH_CSS_STYLE = {
    notice: 'alert-info',
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-danger'
  }.freeze

  def flash_class(message_type)
    FLASH_CSS_STYLE[message_type.to_sym]
  end
end
