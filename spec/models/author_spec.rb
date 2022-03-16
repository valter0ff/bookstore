# frozen_string_literal: true

RSpec.describe Author do
  subject(:author) { build(:author) }

  it 'has a valid factory' do
    expect(build(:author)).to be_valid
  end

  it 'is valid with valid attributes' do
    expect(author).to be_valid
  end
end
