# frozen_string_literal: true

module Pages
  module Sections
    class CheckoutProgressBar < SitePrism::Section
      element :step_number_one, 'span.step-one'
      element :step_number_two, 'span.step-two'
      element :step_number_three, 'span.step-three'
      element :step_number_four, 'span.step-four'
      element :step_number_five, 'span.step-five'
      element :address_label, '.address-label', text: I18n.t('checkout.checkout_progress.address')
      element :delivery_label, '.delivery-label', text: I18n.t('checkout.checkout_progress.delivery')
      element :payment_label, '.payment-label', text: I18n.t('checkout.checkout_progress.payment')
      element :confirm_label, '.confirm-label', text: I18n.t('checkout.checkout_progress.confirm')
      element :complete_label, '.complete-label', text: I18n.t('checkout.checkout_progress.complete')
    end
  end
end
