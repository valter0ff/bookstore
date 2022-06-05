# frozen_string_literal: true

RSpec.describe 'Checkouts->Login', type: :feature do
  let(:checkout_login_page) { Pages::Checkout::Login.new }

  before { checkout_login_page.load }

  describe 'loading page elements' do
    context 'when main page' do
      it 'all elements present' do
        expect(checkout_login_page).to have_login_title(text: I18n.t('checkouts.login.returning_customer'))
        expect(checkout_login_page).to have_fast_sign_up_title(text: I18n.t('checkouts.login.new_customer'))
        expect(checkout_login_page).to have_facebook_login_button
      end
    end

    context 'when login form' do
      let(:login_form) { checkout_login_page.login_form }

      it 'all elements present' do
        expect(login_form).to have_login_subtitle(text: I18n.t('checkouts.login.log_in_with_password'))
        expect(login_form).to have_email_label(text: I18n.t('checkouts.login.enter_email'))
        expect(login_form).to have_email_input
        expect(login_form).to have_password_label(text: I18n.t('checkouts.login.password'))
        expect(login_form).to have_password_input
        expect(login_form).to have_forgot_password_link(text: I18n.t('checkouts.login.forgot_password'))
        expect(login_form).to have_submit_button
        expect(login_form.submit_button.value).to eq(I18n.t('checkouts.login.log_in_with_password'))
      end
    end

    context 'when fast-sign-up form' do
      let(:fast_sign_up_form) { checkout_login_page.fast_sign_up_form }

      it 'all elements present' do
        expect(fast_sign_up_form).to have_fast_sign_up_subtitle(text: I18n.t('checkouts.login.quick_register'))
        expect(fast_sign_up_form).to have_info_text(text: I18n.t('checkouts.login.password_later'))
        expect(fast_sign_up_form).to have_email_label(text: I18n.t('checkouts.login.enter_email'))
        expect(fast_sign_up_form).to have_email_input
        expect(fast_sign_up_form).to have_submit_button
        expect(fast_sign_up_form.submit_button.value).to eq(I18n.t('checkouts.login.continue_to_checkout'))
      end
    end
  end

  describe 'submitting forms' do
    shared_examples 'success request' do
      it 'redirects to checkout address page' do
        expect(checkout_login_page).to have_current_path(checkout_address_path)
      end

      it 'shows success flash message' do
        expect(checkout_login_page).to have_flash_notice(text: notice_message)
      end
    end

    context 'when submit login form' do
      let(:login_form) { checkout_login_page.login_form }

      context 'when valid user email and password' do
        let(:user) { create(:user_account) }
        let(:notice_message) { I18n.t('devise.sessions.signed_in') }

        before { login_form.sign_in_user(user.email, user.password) }

        it_behaves_like 'success request'
      end

      context 'when not valid email or password' do
        let(:user) { create(:user_account) }
        let(:random_password) { FFaker::Internet.password }
        let(:error_message) { I18n.t('devise.failure.invalid', authentication_keys: 'Email') }

        before { login_form.sign_in_user(user.email, random_password) }

        it 'redirects to users login page' do
          expect(checkout_login_page).to have_current_path(new_user_session_path)
        end

        it 'shows apropriate flash message' do
          expect(checkout_login_page).to have_flash_alert(text: error_message)
        end
      end
    end

    context 'when submit fast-sign-up form' do
      let(:errors_path) { %w[activerecord errors models user_account attributes] }
      let(:fast_sign_up_form) { checkout_login_page.fast_sign_up_form }

      before { fast_sign_up_form.register_account(email) }

      context 'when email format is correct' do
        let(:email) { FFaker::Internet.email }
        let(:notice_message) { I18n.t('devise.registrations.account_created') }

        it_behaves_like 'success request'
      end

      context 'when email format is incorrect' do
        let(:email) { FFaker::Lorem.word }
        let(:error_message) { I18n.t('email.invalid', scope: errors_path) }

        it 'shows error message in form' do
          expect(fast_sign_up_form).to have_error_message(text: error_message)
        end
      end

      context 'when account with provided email already exists' do
        let(:user) { create(:user_account) }
        let(:email) { user.email }
        let(:error_message) { I18n.t('email.taken', scope: errors_path) }

        it 'shows error message in form' do
          expect(fast_sign_up_form).to have_error_message(text: error_message)
        end
      end
    end
  end
end
