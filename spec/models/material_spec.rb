# frozen_string_literal: true

RSpec.describe Material do
  subject(:material) { create(:material) }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:book_materials).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:book_materials) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
  end
end
