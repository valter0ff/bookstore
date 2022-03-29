# frozen_string_literal: true

module Pages
  module Devise
    module Sessions
      class New < SitePrism::Page
        set_url '/users/login'

        element :flash_alert, '#flash_alert'
        element :flash_notice, '#flash_notice'
        element :page_title, '.general-login-title', text: I18n.t('devise.sessions.new.log_in')
        element :facebook_login_button, 'a.facebook-login-btn'

        section :form, 'form.general-form' do
          element :email_label, 'label.email-label', text: I18n.t('devise.sessions.new.email')
          element :email_input, 'input#email'
          element :password_label, 'label.password-label', text: I18n.t('devise.sessions.new.password')
          element :password_input, 'input#password'
          element :remember_me_checkbox, '.remember-me-checkbox'
          element :forgot_password, 'a.forgot-password'
          element :submit_button, 'input.submit-btn'
          element :error_message, '.error.text-danger'
        end

        element :account_question, '.account-question'
        element :sign_up_link, 'a.sign-up-link', text: I18n.t('devise.registrations.new.sign_up')

        def log_in_user(email, password)
          form.email_input.set(email)
          form.password_input.set(password)
          form.submit_button.click
        end
      end
    end
  end
end
