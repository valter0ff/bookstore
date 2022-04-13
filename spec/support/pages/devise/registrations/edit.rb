# frozen_string_literal: true

module Pages
  module Devise
    module Registrations
      class Edit < SitePrism::Page
        set_url '/users/edit'

        element :page_title, 'h1.general-title-margin', text: I18n.t('partials.account_settings_menu.title')
        element :address_tab, 'a.address-tab', text: I18n.t('partials.account_settings_menu.address')
        element :privacy_tab, 'a.privacy-tab', text: I18n.t('partials.account_settings_menu.privacy')
        element :flash_notice, '#flash_notice'

        section :email_form, '.email-form' do
          element :email_label, 'label.email-label', text: I18n.t('users.registrations.edit.enter_email')
          element :email_input, 'input#email'
          element :error_message, '.error.text-danger'
          element :submit_btn, 'input.btn-default'
        end

        section :password_form, '.password-form' do
          element :current_password_label, 'label.current-password-label',
                  text: I18n.t('users.registrations.edit.old_password')
          element :current_password_input, 'input#current_password'
          element :new_password_label, 'label.password-label', text: I18n.t('users.registrations.edit.new_password')
          element :new_password_input, 'input#password'
          element :password_confirmation_label, 'label.confirmation-label',
                  text: I18n.t('users.registrations.edit.confirm_password')
          element :password_confirmation_input, 'input#confirm_password'
          element :error_message, '.error.text-danger'
          element :submit_btn, 'input.btn-default'
        end

        section :remove_account_form, '.remove-account-block' do
          element :form_title, 'p.in-gold-500', text: I18n.t('users.registrations.edit.remove_account_title')
          element :remove_account_button, 'a.btn-default',
                  text: I18n.t('users.registrations.edit.remove_account_button')
          element :confirmation_checkbox, '.form-group.checkbox'
        end

        def fill_and_submit_email_form(email)
          email_form.email_input.set(email)
          email_form.submit_btn.click
        end

        def fill_and_submit_password_form(old_password, new_password)
          password_form.current_password_input.set(old_password)
          password_form.new_password_input.set(new_password)
          password_form.password_confirmation_input.set(new_password)
          password_form.submit_btn.click
        end

        def remove_account
          remove_account_form.confirmation_checkbox.click
          remove_account_form.remove_account_button.click
        end
      end
    end
  end
end
