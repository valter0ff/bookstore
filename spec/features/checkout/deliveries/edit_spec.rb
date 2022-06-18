# frozen_string_literal: true

RSpec.describe 'Checkout::Deliveries->Edit', type: :feature do
  let(:deliveries_edit_page) { Pages::Checkout::Deliveries::Edit.new }
  let(:user) { create(:user_account) }

  before do
    sign_in(user)
    create_list(:shipping_method, rand(2..5))
    deliveries_edit_page.load
  end

  describe 'loading page elements' do
    context 'when whole page' do
      it 'all elements present' do
        expect(deliveries_edit_page).to have_page_title(text: I18n.t('checkout.shared.general_title'))
        expect(deliveries_edit_page).to have_shipping_subtitle(text: I18n.t('checkout.deliveries.edit.shipping_method'))
        expect(deliveries_edit_page).to have_checkout_progress_bar
        expect(deliveries_edit_page).to have_shipping_methods_form
        expect(deliveries_edit_page).to have_order_summary_title
        expect(deliveries_edit_page).to have_order_summary_table
        expect(deliveries_edit_page).to have_submit_button
      end
    end

    context 'when checkout progress bar' do
      let(:progress_bar) { deliveries_edit_page.checkout_progress_bar }

      it_behaves_like 'checkout progressbar have all elements'
    end

    context 'when shipping form and shipping method info block' do
      let(:shipping_form) { deliveries_edit_page.shipping_methods_form }
      let(:shipping_method_block) { shipping_form.shipping_method_info.first }

      it 'form elements present' do
        expect(shipping_form).to have_shipping_name_title(text: I18n.t('checkout.deliveries.edit.method'))
        expect(shipping_form).to have_shipping_time_title(text: I18n.t('checkout.deliveries.edit.days'))
        expect(shipping_form).to have_shipping_price_title(text: I18n.t('checkout.deliveries.edit.price'))
        expect(shipping_form).to have_shipping_method_info
      end

      it 'info block elements present' do
        expect(shipping_method_block).to have_shipping_name
        expect(shipping_method_block).to have_shipping_time
        expect(shipping_method_block).to have_shipping_price
        expect(shipping_method_block).to have_radio_button
      end
    end

    context 'when order summary table' do
      let(:order_summary) { deliveries_edit_page.order_summary_table }

      it_behaves_like 'order summary block have all elements'

      it 'order summary block have shipping amount' do
        expect(order_summary).to have_shipping_title(text: I18n.t('checkout.order_summary_table.shipping'))
        expect(order_summary).to have_shipping_amount
      end
    end
  end

  describe 'submitting form' do
    let(:shipping_form) { deliveries_edit_page.shipping_methods_form }
    let(:shipping_method_block) { shipping_form.shipping_method_info.first }

    context 'when success' do
      let(:success_message) { I18n.t('checkout.deliveries.new.shipping_method_saved') }

      before do
        shipping_form.shipping_method_info.first.radio_button.click
        deliveries_edit_page.submit_button.click
      end

      it 'redirects to checkout delivery page' do
        expect(deliveries_edit_page).to have_current_path(edit_checkout_payment_path)
      end

      it 'shows success flash message' do
        expect(deliveries_edit_page).to have_flash_notice(text: notice_message)
      end
    end

    context 'when failed' do
      let(:error_message) { I18n.t('checkout.deliveries.edit.choose_method') }

      before { deliveries_edit_page.submit_button.click }

      it 'shows error flash message' do
        expect(deliveries_edit_page).to have_flash_alert(text: error_message)
      end
    end
  end
end
