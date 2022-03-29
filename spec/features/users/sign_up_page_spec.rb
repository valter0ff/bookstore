# frozen_string_literal: true

RSpec.describe 'UserAccounts', type: :feature do
  describe 'registrations#new' do
    let(:sign_up_page) { Pages::Devise::Registrations::New.new }
    let!(:email) { FFaker::Internet.email }
    let!(:password) { '123456aA' }

    before { sign_up_page.load }

    context 'when all elements present' do
      it { expect(sign_up_page).to have_log_in_link }
      it { expect(sign_up_page).to have_facebook_login_button }
      it { expect(sign_up_page).to have_account_question }
      it { expect(sign_up_page).to have_page_title }
    end

    context 'when all form elements present' do
      let(:sign_up_form) { sign_up_page.form }

      it { expect(sign_up_form).to have_email_label }
      it { expect(sign_up_form).to have_email_input }
      it { expect(sign_up_form).to have_password_label }
      it { expect(sign_up_form).to have_password_input }
      it { expect(sign_up_form).to have_confirmation_label }
      it { expect(sign_up_form).to have_confirmation_input }
      it { expect(sign_up_form).to have_submit_button }
    end

    context 'when user registers successfuly' do
      let(:sign_up_user) { sign_up_page.sign_up_user(email, password) }
      let(:account_menu) { sign_up_page.account_menu }
      let(:notice_message) { 'Welcome! You have signed up successfully.' }

      it 'dispays Account menu in up right corner' do
        sign_up_user
        expect(sign_up_page).to have_my_account_link
        expect(account_menu).to have_orders_link
        expect(account_menu).to have_settings_link
        expect(account_menu).to have_log_out_link
      end

      it 'creates new user account' do
        expect { sign_up_user }.to change(UserAccount, :count).by(1)
      end

      it 'creates user with apropriate email' do
        sign_up_user
        created_user = UserAccount.last
        expect(created_user.email).to eq(email)
      end

      it 'redirects to root path' do
        sign_up_user
        expect(page).to have_current_path(root_path)
      end

      it 'shows apropriate flash message' do
        sign_up_user
        expect(sign_up_page).to have_flash_notice
        expect(sign_up_page.flash_notice.text).to eq(notice_message)
      end
    end

    context 'when not valid confirmation' do
      let(:sign_up_form) { sign_up_page.form }
      let(:error_message) { 'Password confirmation doesn\'t match Password' }

      it 'shows error message' do
        sign_up_page.sign_up_user(email, password, "#{password}1")
        expect(sign_up_form.error_message.text).to eq(error_message)
      end
    end

    context 'when email exists' do
      let(:sign_up_form) { sign_up_page.form }
      let(:error_message) { 'Email has already been taken' }

      it 'shows error message' do
        create(:user_account, email: email)
        sign_up_page.sign_up_user(email, password)
        expect(sign_up_form.error_message.text).to eq(error_message)
      end
    end
  end
end
