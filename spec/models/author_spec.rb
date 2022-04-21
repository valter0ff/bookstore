# frozen_string_literal: true

RSpec.describe Author do
  subject(:author) { create(:author) }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:author_books).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:author_books) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
  end

  describe 'ActiveModel validations' do
    let(:blank_error) { I18n.t('activerecord.errors.messages.blank') }

    context 'when first_name' do
      it { is_expected.to validate_presence_of(:first_name).with_message(blank_error) }
      it { is_expected.to validate_length_of(:first_name).is_at_most(Constants::Author::STRING_MAX_SIZE) }
    end

    context 'when last_name' do
      it { is_expected.to validate_presence_of(:last_name).with_message(blank_error) }
      it { is_expected.to validate_length_of(:last_name).is_at_most(Constants::Author::STRING_MAX_SIZE) }
    end

    context 'when description' do
      it { is_expected.to validate_presence_of(:description).with_message(blank_error) }
      it { is_expected.to validate_length_of(:description).is_at_most(Constants::Author::STRING_MAX_SIZE) }
    end
  end
end
