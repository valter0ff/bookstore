# frozen_string_literal: true

class Picture < ApplicationRecord
  include Imageable

  belongs_to :imageable, polymorphic: true, optional: true
end
