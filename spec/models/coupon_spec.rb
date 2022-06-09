# frozen_string_literal: true

RSpec.describe Coupon do
  subject(:coupon) { create(:coupon) }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:orders) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:code).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:discount).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:code) }
  end

  describe 'ActiveModel validations' do
    it { is_expected.to validate_uniqueness_of(:code) }
  end
end
