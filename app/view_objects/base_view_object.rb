# frozen_string_literal: true

class BaseViewObject < SimpleDelegator
  attr_reader :context

  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  include ActionView::Context

  def initialize(context, options = {})
    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
    super(context)
  end

  def h
    __getobj__
  end
end
