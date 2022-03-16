# frozen_string_literal: true

RSpec.describe Book do
  subject(:book) { described_class.new(title: good_title, category: category) }

  let(:good_title) { FFaker::Book.unique.genre }
  let(:category) { Category.new(title: good_title) }

  it 'is valid with valid attributes' do
    expect(book).to be_valid
  end

  it 'is not valid without a title' do
    book.title = nil
    expect(book).not_to be_valid
  end
end
