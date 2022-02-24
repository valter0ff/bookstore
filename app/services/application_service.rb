# frozen_string_literal: true

class ApplicationService < SimpleDelegator
  def self.call(...)
    new(...).call
  end
end
