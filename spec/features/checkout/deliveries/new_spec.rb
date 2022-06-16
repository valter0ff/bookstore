# frozen_string_literal: true

RSpec.describe 'Checkout::Deliveries->New', type: :feature do
  let(:deliveries_new_page) { Pages::Checkout::Deliveries::New.new }
  let(:user) { create(:user_account) }

  before do
    sign_in(user)
    create_list(:shipping_method, rand(2..5))
    deliveries_new_page.load
  end

  describe 'loading page elements' do
    context 'when whole page' do
      it 'all elements present' do
        expect(deliveries_new_page).to have_page_title(text: I18n.t('checkout.shared.general_title'))
        expect(deliveries_new_page).to have_shipping_subtitle(text: I18n.t('checkout.deliveries.new.shipping_method'))
        expect(deliveries_new_page).to have_checkout_progress_bar
        expect(deliveries_new_page).to have_shipping_methods_form
        expect(deliveries_new_page).to have_order_summary_title
        expect(deliveries_new_page).to have_order_summary_table
        expect(deliveries_new_page).to have_submit_button
      end
    end

    context 'when checkout progress bar' do
      let(:progress_bar) { deliveries_new_page.checkout_progress_bar }

      it_behaves_like 'checkout progressbar have all elements'
    end

    context 'when shipping form and shipping method info block' do
      let(:shipping_form) { deliveries_new_page.shipping_methods_form }
      let(:shipping_method_block) { shipping_form.shipping_method_info.first }

      it 'form elements present' do
        expect(shipping_form).to have_shipping_name_title(text: I18n.t('checkout.deliveries.new.method'))
        expect(shipping_form).to have_shipping_time_title(text: I18n.t('checkout.deliveries.new.days'))
        expect(shipping_form).to have_shipping_price_title(text: I18n.t('checkout.deliveries.new.price'))
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
      let(:order_summary) { deliveries_new_page.order_summary_table }

      it_behaves_like 'order summary block have all elements'

      it 'order summary block have shipping amount' do
        expect(order_summary).to have_shipping_title(text: I18n.t('checkout.order_summary_table.shipping'))
        expect(order_summary).to have_shipping_amount
      end
    end
  end
end
