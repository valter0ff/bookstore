# frozen_string_literal: true

RSpec.describe Review do
  let(:review) { create(:review) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user_account) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:rating).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:body).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:user_account_id).of_type(:integer).with_options(null: false) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:book_id) }
    it { is_expected.to have_db_index(:user_account_id) }
  end

  describe 'ActiveModel validations' do
    let(:errors_path) { %w[activerecord errors models review attributes] }
    let(:blank_error) { I18n.t('activerecord.errors.messages.blank') }

    context 'when title' do
      let(:invalid_error) { I18n.t('title.invalid', scope: errors_path) }

      it { is_expected.to validate_presence_of(:title).with_message(blank_error) }
      it { is_expected.to validate_length_of(:title).is_at_most(Constants::Review::TITLE_MAX_SIZE) }
      it { is_expected.to allow_value(FFaker::Lorem.unique.phrase).for(:title) }
      it { is_expected.not_to allow_value(FFaker::Internet.email).for(:title).with_message(invalid_error) }
    end

    context 'when body' do
      let(:invalid_error) { I18n.t('body.invalid', scope: errors_path) }

      it { is_expected.to validate_presence_of(:body).with_message(blank_error) }
      it { is_expected.to validate_length_of(:body).is_at_most(Constants::Review::BODY_MAX_SIZE) }
      it { is_expected.to allow_value(FFaker::Lorem.unique.paragraph).for(:body) }
      it { is_expected.not_to allow_value(FFaker::Internet.email).for(:body).with_message(invalid_error) }
    end
  end
end
