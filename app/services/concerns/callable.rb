# frozen_string_literal: true

module Callable
  extend ActiveSupport::Concern

  def call(...)
    new(...).call
  end
end
