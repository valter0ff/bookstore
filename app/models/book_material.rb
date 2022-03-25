# frozen_string_literal: true

class BookMaterial < ApplicationRecord
  belongs_to :book
  belongs_to :material
end
