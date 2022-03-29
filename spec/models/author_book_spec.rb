# frozen_string_literal: true

RSpec.describe AuthorBook do
  describe 'associations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:author) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
    it { is_expected.to have_db_column(:author_id).of_type(:integer) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:book_id) }
    it { is_expected.to have_db_index(:author_id) }
  end
end
