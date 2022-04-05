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
    context 'when validates presence' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_presence_of(:address) }
      it { is_expected.to validate_presence_of(:city) }
      it { is_expected.to validate_presence_of(:zip) }
      it { is_expected.to validate_presence_of(:country_code) }
      it { is_expected.to validate_presence_of(:phone) }
      it { is_expected.to validate_presence_of(:type) }
    end
  end
end
