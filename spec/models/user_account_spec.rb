# frozen_string_literal: true

RSpec.describe UserAccount, type: :model do
  subject(:user_account) { create(:user_account) }

  describe 'ActiveModel validations' do
    let(:errors_path) { %w[activerecord errors models user_account attributes] }
    let(:blank_error) { I18n.t('activerecord.errors.messages.blank') }

    context 'when email' do
      let(:taken_error) { I18n.t('email.taken', scope: errors_path) }
      let(:invalid_error) { I18n.t('email.invalid', scope: errors_path) }

      it { is_expected.to validate_presence_of(:email).with_message(blank_error).on(:create) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive.with_message(taken_error) }
      it { is_expected.to allow_value(FFaker::Internet.email).for(:email) }
      it { is_expected.not_to allow_value(FFaker::Lorem.word).for(:email).with_message(invalid_error) }
    end

    context 'when password' do
      let(:invalid_error) { I18n.t('password.invalid', scope: errors_path) }

      it { is_expected.to validate_presence_of(:password).with_message(blank_error).on(:create) }
      it { is_expected.to validate_length_of(:password).is_at_most(Constants::UserAccount::PASSWORD_MAX_SIZE) }
      it { is_expected.to allow_value("#{FFaker::Internet.password}aA1").for(:password) }
      it { is_expected.not_to allow_value(FFaker::Lorem.phrase).for(:password).with_message(invalid_error) }
    end
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:email) }
    it { is_expected.to have_db_index(:reset_password_token) }
  end

  describe 'associatios' do
    it { is_expected.to have_one(:shipping_address).dependent(:destroy) }
    it { is_expected.to have_one(:billing_address).dependent(:destroy) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:orders) }
    it { is_expected.to have_one(:picture).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for(:picture).allow_destroy(true) }
  end
end
