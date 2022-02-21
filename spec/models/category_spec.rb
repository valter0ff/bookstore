# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  subject(:category) { described_class.new }

  it 'is valid with provided title' do
    category.title = FFaker::Book.unique.genre
    expect(category).to be_valid
  end

  it 'is not valid without a title' do
    category.title = nil
    expect(category).not_to be_valid
  end
end
