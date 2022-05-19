# frozen_string_literal: true

RSpec.describe CartItem do
  subject(:cart_item) { create(:cart_item) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:order_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:books_count).of_type(:integer) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:order_id) }
    it { is_expected.to have_db_index(:book_id) }
  end
end
