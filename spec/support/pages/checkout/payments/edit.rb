# frozen_string_literal: true

module Pages
  module Checkout
    module Payments
      class Edit < SitePrism::Page
        set_url '/checkout/payment/edit'

        element :flash_notice, '#flash_notice'
        element :page_title, '.general-title-margin'
        element :payment_subtitle, '.general-subtitle'
        element :order_summary_title, '.order-summary-title'

        section :checkout_progress_bar, Pages::Sections::CheckoutProgressBar, '.checkout-progress'
        section :order_summary_table, Pages::Sections::OrderSummary, '.general-summary-table'

        section :credit_card_form, '.credit-card-form' do
          element :card_number_label, '.card-number-label'
          element :card_number_input, '#card-number'
          element :holder_name_label, '.holder-name-label'
          element :holder_name_input, '#holder-name'
          element :expiry_date_label, '.expiry-date-label'
          element :expiry_date_input, '#expiry-date'
          element :cvv_code_label, '.cvv-code-label'
          element :cvv_code_input, '#cvv-code'
          element :card_number_error, '#card-number-error'
          element :holder_name_error, '#holder-name-error'
          element :expiry_date_error, '#expiry-date-error'
          element :cvv_code_error, '#cvv-code-error'
          element :submit_button, 'input.submit-btn'

          def fill_and_submit(params)
            card_number_input.set(params[:number])
            holder_name_input.set(params[:holder_name])
            expiry_date_input.set(params[:expiry_date])
            cvv_code_input.set(params[:cvv_code])
            submit_button.click
          end
        end
      end
    end
  end
end
