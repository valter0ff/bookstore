# frozen_string_literal: true

RSpec.describe Review do
  let(:review) { create(:review) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:book) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:rating).of_type(:integer) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer).with_options(null: false) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:book_id) }
  end
end
