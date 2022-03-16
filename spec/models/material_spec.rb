# frozen_string_literal: true

RSpec.describe Material do
  subject(:material) { described_class.new(title: good_title) }

  let(:good_title) { FFaker::Lorem.word }

  it 'is valid with valid attributes' do
    expect(material).to be_valid
  end
end
