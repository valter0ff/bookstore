# frozen_string_literal: true

RSpec.describe Address, type: :model do
  subject(:address) { create(:address, user_account: user) }

  let(:user) { create(:user_account) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:user_account) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:address).of_type(:string) }
    it { is_expected.to have_db_column(:city).of_type(:string) }
    it { is_expected.to have_db_column(:zip).of_type(:string) }
    it { is_expected.to have_db_column(:country_code).of_type(:string) }
    it { is_expected.to have_db_column(:phone).of_type(:string) }
    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:user_account_id).of_type(:integer) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:user_account_id) }
  end

  describe 'ActiveModel validations' do
    let(:attr_max_size) { Constants::Address::COMMON_INFO_MAX_SIZE }
    let(:attr_restricted_value) { FFaker::Internet.email }

    context 'when first_name' do
      it_behaves_like 'validatable atrribute', :first_name
    end

    context 'when last_name' do
      it_behaves_like 'validatable atrribute', :last_name
    end

    context 'when city' do
      it_behaves_like 'validatable atrribute', :city
    end

    context 'when address' do
      it_behaves_like 'validatable atrribute', :address
    end

    context 'when country_code' do
      it_behaves_like 'validatable atrribute', :country_code
    end

    context 'when zip' do
      let(:attr_max_size) { Constants::Address::ZIP_MAX_SIZE }

      it_behaves_like 'validatable atrribute', :zip
    end

    context 'when phone' do
      let(:attr_max_size) { Constants::Address::PHONE_MAX_SIZE }

      it_behaves_like 'validatable atrribute', :phone
    end

    context 'when type' do
      it { is_expected.to validate_presence_of(:type) }
    end
  end

  describe '#country_name' do
    let(:address) { create(:address, country_code: 'US', user_account: user) }
    let(:expected_result) { 'United States' }

    it 'returns apropriate country name' do
      expect(address.country_name).to eq(expected_result)
    end
  end
end
