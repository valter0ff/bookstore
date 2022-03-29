# frozen_string_literal: true

RSpec.describe 'UserAccounts', type: :feature do
  describe 'passwords#new' do
    let(:new_password_page) { Pages::Devise::Passwords::New.new }
    let(:notice_message) { I18n.t('devise.passwords.send_instructions') }
    let(:form) { new_password_page.form }
    let!(:user) { create(:user_account) }
    let(:send_instructions) { new_password_page.send_email(user.email) }

    before { new_password_page.load }

    context 'when all page elements present' do
      it { expect(new_password_page).to have_page_title }
      it { expect(new_password_page).to have_page_description }
      it { expect(form).to have_email_input }
      it { expect(form).to have_submit_button }
      it { expect(form).to have_cancel_button }
    end

    context 'when email exists' do
      it 'redirects user to root' do
        send_instructions
        expect(page).to have_current_path(new_user_session_path)
      end

      it 'shows flash notice message' do
        send_instructions
        expect(new_password_page).to have_flash_notice
        expect(new_password_page.flash_notice.text).to eq(notice_message)
      end
    end
  end
end
