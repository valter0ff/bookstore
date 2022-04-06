# frozen_string_literal: true

RSpec.describe UserAccount, type: :model do
  subject(:user_account) { create(:user_account) }

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.to validate_presence_of(:email).on(:create) }

    context 'when validates format' do
      it 'allows valid passwords' do
        expect(user_account).to allow_value('open4G333', 'closG444ed')
          .for(:password)
          .with_message(I18n.t('errors.messages.password_complexity'))
      end

      it 'rejects invalid passwords' do
        expect(user_account).not_to allow_value('open33', 'closed')
          .for(:password)
          .with_message(I18n.t('errors.messages.password_complexity'))
      end

      it 'allows valid emails' do
        expect(user_account).to allow_value('example.!#$%&.444@dot4444.com', 'clos-G44-4ed.time*+-/=?^_`{|}~@000.000')
          .for(:email)
          .with_message(I18n.t('errors.messages.email_format'))
      end

      it 'rejects invalid emails' do
        expect(user_account).not_to allow_value('-open33-@ff.ff', 'clo--sed@aa.aa', '.open.@dd.dd', 'feat..ured@ww.ww')
          .for(:email)
          .with_message(I18n.t('errors.messages.email_format'))
      end
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
end
