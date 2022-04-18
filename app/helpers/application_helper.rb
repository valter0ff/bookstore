# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def present(model)
    klass = "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
    presenter
  end
end
