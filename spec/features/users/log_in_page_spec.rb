# frozen_string_literal: true

RSpec.describe 'UserAccounts', type: :feature do
  describe 'sessions#new' do
    let(:log_in_page) { Pages::Devise::Sessions::New.new }

    before { log_in_page.load }

    context 'when checks page elements' do
      it { expect(log_in_page).to have_page_title }
      it { expect(log_in_page).to have_facebook_login_button }
      it { expect(log_in_page).to have_account_question }
      it { expect(log_in_page).to have_sign_up_link }
    end

    context 'when checks form elements' do
      let(:log_in_form) { log_in_page.form }

      it { expect(log_in_form).to have_email_label }
      it { expect(log_in_form).to have_email_input }
      it { expect(log_in_form).to have_password_label }
      it { expect(log_in_form).to have_password_input }
      it { expect(log_in_form).to have_forgot_password }
      it { expect(log_in_form).to have_remember_me_checkbox }
      it { expect(log_in_form).to have_submit_button }
    end

    context 'when user signs in successfuly' do
      let(:user) { create(:user_account) }
      let(:log_in_user) { log_in_page.log_in_user(user.email, user.password) }
      let(:notice_message) { 'Signed in successfully.' }

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
      let(:random_email) { 'hello@gmail.com' }
      let(:log_in_user) { log_in_page.log_in_user(random_email, user.password) }
      let(:error_message) { 'Invalid Email or password.' }

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
