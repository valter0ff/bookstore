# frozen_string_literal: true

RSpec.describe 'Checkout::Addresses->Edit', type: :feature do
  let(:addresses_edit_page) { Pages::Checkout::Addresses::Edit.new }
  let(:user) { create(:user_account) }

  before do
    sign_in(user)
    addresses_edit_page.load
  end

  describe 'loading page elements' do
    context 'when whole page' do
      it 'all elements present' do
        expect(addresses_edit_page).to have_page_title(text: I18n.t('checkout.shared.general_title'))
        expect(addresses_edit_page).to have_use_billing_checkbox
        expect(addresses_edit_page).to have_submit_button
        expect(addresses_edit_page).to have_billing_title(text: I18n.t('addresses.new.billing_title'))
        expect(addresses_edit_page).to have_shipping_title(text: I18n.t('addresses.new.shipping_title'))
        expect(addresses_edit_page).to have_billing_form
        expect(addresses_edit_page).to have_shipping_form
        expect(addresses_edit_page).to have_checkout_progress_bar
        expect(addresses_edit_page).to have_order_summary_table
      end
    end

    context 'when checkout progress bar' do
      let(:progress_bar) { addresses_edit_page.checkout_progress_bar }

      it_behaves_like 'checkout progressbar have all elements'
    end

    context 'when billing form' do
      let(:form) { addresses_edit_page.billing_form }

      it_behaves_like 'form have all elements'
    end

    context 'when shipping form' do
      let(:form) { addresses_edit_page.shipping_form }

      it_behaves_like 'form have all elements'
    end

    context 'when order summary table' do
      let(:order_summary) { addresses_edit_page.order_summary_table }

      it_behaves_like 'order summary block have all elements'
    end
  end

  describe 'submitting form' do
    let(:billing_form) { addresses_edit_page.billing_form }
    let(:shipping_form) { addresses_edit_page.shipping_form }
    let(:success_message) { I18n.t('checkout.addresses.edit.addresses_saved') }

    shared_examples 'success request' do
      it 'redirects to checkout delivery page' do
        expect(addresses_edit_page).to have_current_path(edit_checkout_delivery_path)
      end

      it 'shows success flash message' do
        expect(addresses_edit_page).to have_flash_notice(text: success_message)
      end
    end

    context 'when both forms filled' do
      before do
        addresses_edit_page.fill_form_fields(billing_form, billing_attrs)
        addresses_edit_page.fill_form_fields(shipping_form, shipping_attrs)
        addresses_edit_page.submit_button.click
      end

      context 'with all fields correct data' do
        let(:billing_attrs) { attributes_for(:billing_address) }
        let(:shipping_attrs) { attributes_for(:shipping_address) }

        it_behaves_like 'a successfull address change' do
          let(:address) { user.reload.billing_address }
          let(:request_params) { billing_attrs }
        end

        it_behaves_like 'a successfull address change' do
          let(:address) { user.reload.shipping_address }
          let(:request_params) { shipping_attrs }
        end

        it_behaves_like 'success request'
      end

      context 'with some fields incorrect data' do
        let(:billing_attrs) { attributes_for(:billing_address, city: FFaker::Internet.email) }
        let(:shipping_attrs) { attributes_for(:shipping_address, zip: '') }
        let(:errors_path) { %w[activerecord errors models address attributes] }
        let(:format_error_message) { I18n.t('city.invalid', scope: errors_path) }
        let(:blank_error_message) { I18n.t('activerecord.errors.messages.blank') }

        it 'shows errors messages in form' do
          expect(billing_form).to have_error_message(text: format_error_message)
          expect(shipping_form).to have_error_message(text: blank_error_message)
        end
      end
    end

    context 'when use_billing_address checkbox active', js: true do
      let(:billing_attrs) { attributes_for(:billing_address) }

      before do
        addresses_edit_page.fill_form_fields(billing_form, billing_attrs)
        addresses_edit_page.use_billing_checkbox.click
        addresses_edit_page.submit_button.click
      end

      it_behaves_like 'a successfull address change' do
        let(:address) { user.reload.billing_address }
        let(:request_params) { billing_attrs }
      end

      it_behaves_like 'success request'

      it 'doesn`t update shipping address' do
        expect(user.reload.shipping_address).to be_nil
      end
    end
  end
end
