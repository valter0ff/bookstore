# frozen_string_literal: true

RSpec.describe CreditCard, type: :model do
  subject(:credit_card) { create(:credit_card) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:order) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:number).of_type(:bigint) }
    it { is_expected.to have_db_column(:holder_name).of_type(:string) }
    it { is_expected.to have_db_column(:expiry_date).of_type(:string) }
    it { is_expected.to have_db_column(:cvv_code).of_type(:string) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:order_id) }
  end

  describe 'ActiveModel validations' do
    let(:errors_path) { %w[activerecord errors models credit_card attributes] }
    let(:blank_error) { I18n.t('activerecord.errors.messages.blank') }

    context 'when card number' do
      let(:invalid_error) { I18n.t('number.invalid', scope: errors_path) }

      it { is_expected.to validate_presence_of(:number).with_message(blank_error) }
      it { is_expected.to validate_length_of(:number).is_at_least(Constants::CreditCard::NUMBER_MIN_SIZE) }
      it { is_expected.to validate_length_of(:number).is_at_most(Constants::CreditCard::NUMBER_MAX_SIZE) }
      it { is_expected.to allow_value(FFaker::Bank.card_number.delete(' ')).for(:number) }
      it { is_expected.not_to allow_value(FFaker::Lorem.word).for(:number).with_message(invalid_error) }
    end

    context 'when holder name' do
      let(:invalid_error) { I18n.t(errors.messages.invalid) }

      it { is_expected.to validate_presence_of(:holder_name).with_message(blank_error) }
      it { is_expected.to validate_length_of(:holder_name).is_at_most(Constants::CreditCard::HOLDER_NAME_MAX_SIZE) }
      it { is_expected.to allow_value(FFaker::Name.name).for(:holder_name) }
      it { is_expected.not_to allow_value(FFaker::Internet.email).for(:holder_name).with_message(invalid_error) }
    end

    context 'when expiry date' do
      let(:invalid_error) { I18n.t(errors.messages.invalid) }

      it { is_expected.to validate_presence_of(:expiry_date).with_message(blank_error) }
      it { is_expected.to allow_value(FFaker::Bank.card_expiry_date).for(:expiry_date) }
      it { is_expected.not_to allow_value(FFaker::Lore.word).for(:expiry_date).with_message(invalid_error) }
    end

    context 'when cvv code' do
      let(:invalid_error) { I18n.t(errors.messages.invalid) }

      it { is_expected.to validate_presence_of(:cvv_code).with_message(blank_error) }
      it { is_expected.to allow_value(rand(100..9999)).for(:expiry_date) }
      it { is_expected.not_to allow_value(FFaker::Lorem.word).for(:cvv_code).with_message(invalid_error) }
    end
  end
end
