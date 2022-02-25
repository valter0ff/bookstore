# frozen_string_literal: true

class BasePresenter < SimpleDelegator
  def initialize(model, view)
    @view = view
    super(model)
  end

  def h
    @view
  end

  def self.wrap(collection)
    collection.map do |obj|
      new(obj, self)
    end
  end
end
