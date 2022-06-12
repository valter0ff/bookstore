# frozen_string_literal: true

module Pages
  module Checkout
    module Sessions
      class New < SitePrism::Page
        set_url '/checkout/session/new'

        element :flash_notice, '#flash_notice'
        element :flash_alert, '#flash_alert'
        element :login_title, '.login-title'
        element :sign_up_title, '.sign-up-title'
        elements :facebook_login_button, 'a.facebook-login-btn'

        section :login_form, '.login-form' do
          element :login_subtitle, '.login-subtitle'
          element :email_label, 'label.email-label'
          element :email_input, 'input#email'
          element :password_label, 'label.password-label'
          element :password_input, 'input#password'
          element :forgot_password_link, '.forgot-password'
          element :submit_button, '.submit-btn'

          def sign_in_user(email, password)
            email_input.set(email)
            password_input.set(password)
            submit_button.click
          end
        end

        section :sign_up_form, '.sign-up-form' do
          element :sign_up_subtitle, '.sign-up-subtitle'
          element :info_text, '.general-info-text'
          element :email_label, 'label.email-label'
          element :email_input, 'input#sign-up-email'
          element :error_message, '.error.text-danger'
          element :submit_button, '.submit-btn'

          def register_account(email)
            email_input.set(email)
            submit_button.click
          end
        end
      end
    end
  end
end
