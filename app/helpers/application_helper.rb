# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def present(model)
    klass = "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
  end

  def view_object(name, args = {})
    class_name = if name.is_a?(Symbol)
                   name.to_s.titleize.split.join
                 else
                   name.split('/').map { |n| n.titleize.sub(' ', '') }.join('::')
                 end
    class_name.constantize.new(self, args)
  end
end
