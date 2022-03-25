# frozen_string_literal: true

RSpec.describe UserAccount, type: :model do
  subject(:user_account) { create(:user_account) }

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:email) }
  end
end
