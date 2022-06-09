# frozen_string_literal: true

RSpec.describe Order do
  subject(:order) { create(:order) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:coupon).optional }
    it { is_expected.to belong_to(:user_account).optional }
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:user_account_id).of_type(:integer) }
    it { is_expected.to have_db_column(:coupon_id).of_type(:integer) }
    it { is_expected.to have_db_column(:delivered_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:in_delivery_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:state).of_type(:integer) }
    it { is_expected.to have_db_column(:number).of_type(:string) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:coupon_id) }
    it { is_expected.to have_db_index(:user_account_id) }
  end
end
