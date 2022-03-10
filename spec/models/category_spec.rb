# frozen_string_literal: true

RSpec.describe Category do
  subject(:category) { described_class.new }

  let(:good_title) { FFaker::Book.unique.genre }

  it 'is valid with provided title' do
    category.title = good_title
    expect(category).to be_valid
  end

  it 'is not valid without a title' do
    category.title = nil
    expect(category).not_to be_valid
  end
end
