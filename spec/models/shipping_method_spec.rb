# frozen_string_literal: true

RSpec.describe ShippingMethod, type: :model do
  subject(:shipping_method) { create(:shipping_method) }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:orders).dependent(:nullify) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:days).of_type(:integer) }
    it { is_expected.to have_db_column(:price).of_type(:float) }
  end

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
