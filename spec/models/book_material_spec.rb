# frozen_string_literal: true

RSpec.describe BookMaterial do
  describe 'associations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:material) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
    it { is_expected.to have_db_column(:material_id).of_type(:integer) }
    it { is_expected.to have_db_index(:book_id) }
    it { is_expected.to have_db_index(:material_id) }
  end
end
