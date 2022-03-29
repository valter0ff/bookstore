# frozen_string_literal: true

module Pages
  module Devise
    module Passwords
      class New < SitePrism::Page
        set_url '/users/password/new'

        element :page_title, '.general-password-title', text: I18n.t('devise.passwords.new.title')
        element :page_description, '.general-password-text', text: I18n.t('devise.passwords.new.description')
        element :flash_notice, '#flash_notice'

        section :form, 'form.general-form' do
          element :email_input, 'input.form-control'
          element :submit_button, 'input.submit-btn'
          element :cancel_button, 'a.cancel-btn'
          element :error_message, '.error.text-danger'
        end

        def send_email(email)
          form.email_input.set(email)
          form.submit_button.click
        end
      end
    end
  end
end
