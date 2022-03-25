# frozen_string_literal: true

RSpec.describe Category do
  subject(:category) { create(:category, title: good_title) }

  let(:good_title) { FFaker::Book.unique.genre }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:books).dependent(:destroy) }
  end

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:books_count).of_type(:integer) }
  end
end
