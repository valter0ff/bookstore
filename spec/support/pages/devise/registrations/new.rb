# frozen_string_literal: true

module Pages
  module Devise
    module Registrations
      class New < SitePrism::Page
        set_url '/users/signup'

        element :flash_notice, '#flash_notice'
        element :page_title, '.general-login-title', text: I18n.t('devise.registrations.new.title')

        section :form, '.simple_form.general-form' do
          element :email_label, 'label.email-label', text: I18n.t('devise.registrations.new.email')
          element :email_input, 'input#email'
          element :password_label, 'label.password-label', text: I18n.t('devise.registrations.new.password')
          element :password_input, 'input#password'
          element :confirmation_label, 'label.confirmation-label', text: I18n.t('devise.registrations.new.confirmation')
          element :confirmation_input, 'input#confirm'
          element :submit_button, '.submit-btn'
          element :error_message, '.error.text-danger'
        end

        section :account_menu, 'ul#my-account' do
          element :orders_link, 'li>a.orders-link', text: I18n.t('partials.header.orders')
          element :settings_link, 'li>a.settings-link', text: I18n.t('partials.header.settings')
          element :log_out_link, 'li>a.log-out-link', text: I18n.t('partials.header.log_out')
        end

        element :my_account_link, 'a.my-account-link', text: I18n.t('partials.header.my_account')
        element :account_question, '.account-question', text: I18n.t('devise.registrations.new.account_question')
        element :log_in_link, '.log-in-link', text: I18n.t('devise.registrations.new.log_in')
        element :facebook_login_button, 'a.facebook-login-btn'

        def sign_up_user(email, password, confirmation = password)
          form.email_input.set(email)
          form.password_input.set(password)
          form.confirmation_input.set(confirmation)
          form.submit_button.click
        end
      end
    end
  end
end
