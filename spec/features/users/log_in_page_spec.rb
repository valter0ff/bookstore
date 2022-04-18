# frozen_string_literal: true

RSpec.describe 'UserAccounts', type: :feature do
  describe 'sessions#new' do
    let(:log_in_page) { Pages::Devise::Sessions::New.new }

    before { log_in_page.load }

    context 'when checks page elements' do
      it do
        expect(log_in_page).to have_page_title
        expect(log_in_page).to have_facebook_login_button
        expect(log_in_page).to have_account_question
        expect(log_in_page).to have_sign_up_link
      end
    end

    context 'when all form elements present' do
      let(:log_in_form) { log_in_page.form }

      it do
        expect(log_in_form).to have_email_label
        expect(log_in_form).to have_email_input
        expect(log_in_form).to have_password_label
        expect(log_in_form).to have_password_input
        expect(log_in_form).to have_forgot_password
        expect(log_in_form).to have_remember_me_checkbox
        expect(log_in_form).to have_submit_button
      end
    end

    context 'when user signs in successfuly' do
      let(:user) { create(:user_account) }
      let(:log_in_user) { log_in_page.log_in_user(user.email, user.password) }
      let(:notice_message) { I18n.t('devise.sessions.signed_in') }

      it 'redirects logged in user to root' do
        log_in_user
        expect(page).to have_current_path(root_path)
      end

      it 'shows apropriate flash message' do
        log_in_user
        expect(log_in_page).to have_flash_notice
        expect(log_in_page.flash_notice.text).to eq(notice_message)
      end
    end

    context 'when not valid email or password' do
      let(:user) { create(:user_account) }
      let(:random_email) { FFaker::Internet.email + rand(2).to_s }
      let(:log_in_user) { log_in_page.log_in_user(random_email, user.password) }
      let(:error_message) { I18n.t('devise.failure.invalid', authentication_keys: 'Email') }

      it 'shows apropriate flash message' do
        log_in_user
        expect(log_in_page).to have_flash_alert
        expect(log_in_page.flash_alert.text).to eq(error_message)
      end
    end

    context 'when clicks `forgot password` link' do
      it 'redirects to new user password page' do
        log_in_page.form.forgot_password.click
        expect(page).to have_current_path(new_user_password_path)
      end
    end
  end
end
