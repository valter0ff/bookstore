# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :category, counter_cache: true
  
  validates_presence_of :title
end
