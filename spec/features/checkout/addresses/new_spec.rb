# frozen_string_literal: true

RSpec.describe 'Checkout::Addresses->New', type: :feature do
  let(:addresses_new_page) { Pages::Checkout::Addresses::New.new }
  let(:user) { create(:user_account) }

  before do
    sign_in(user)
    addresses_new_page.load
  end

  context 'when whole page' do
    it 'all elements present' do
      expect(addresses_new_page).to have_page_title(text: I18n.t('checkout.shared.general_title'))
      expect(addresses_new_page).to have_use_billing_checkbox
      expect(addresses_new_page).to have_submit_button
      expect(addresses_new_page).to have_billing_title(text: I18n.t('addresses.new.billing_title'))
      expect(addresses_new_page).to have_shipping_title(text: I18n.t('addresses.new.shipping_title'))
      expect(addresses_new_page).to have_billing_form
      expect(addresses_new_page).to have_shipping_form
      expect(addresses_new_page).to have_checkout_progress_bar
      expect(addresses_new_page).to have_order_summary_table
    end
  end

  context 'when checkout progress bar' do
    let(:progress_bar) { addresses_new_page.checkout_progress_bar }

    it_behaves_like 'checkout progressbar have all elements'
  end

  context 'when billing form' do
    let(:form) { addresses_new_page.billing_form }

    it_behaves_like 'form have all elements'
  end

  context 'when shipping form' do
    let(:form) { addresses_new_page.shipping_form }

    it_behaves_like 'form have all elements'
  end

  context 'when order summary table' do
    let(:order_summary) { addresses_new_page.order_summary_table }

    it_behaves_like 'order summary block have all elements'
  end
end
