# frozen_string_literal: true

RSpec.describe 'Checkout::Completes->Show', type: :feature do
  let(:complete_page) { Pages::Checkout::Completes::Show.new }
  let(:user) { create(:user_account) }
  let(:order) { create(:order, :filled, :completed, user_account: user) }

  before do
    sign_in(user)
    complete_page.load(params: { id: order.id })
  end

  describe 'loading page elements' do
    context 'when whole page' do
      let(:email_sent_message) { I18n.t('checkout.completes.show.email_sent_message', user_email: user.email) }
      let(:order_number_text) { I18n.t('checkout.completes.show.order_number', number: "##{order.number}") }

      it 'all elements present' do
        expect(complete_page).to have_page_title(text: I18n.t('checkout.shared.general_title'))
        expect(complete_page).to have_thank_you_message(text: I18n.t('checkout.completes.show.thank_you_message'))
        expect(complete_page).to have_email_sent_message(text: email_sent_message)
        expect(complete_page).to have_order_number(text: order_number_text)
        expect(complete_page).to have_complete_date(text: order.decorate.complete_date)
        expect(complete_page).to have_order_summary_title(text: I18n.t('carts.show.order_summary'))
        expect(complete_page).to have_back_to_store_button(text: I18n.t('checkout.completes.show.back_to_store'))
      end
    end

    context 'when checkout progress bar' do
      let(:progress_bar) { complete_page.checkout_progress_bar }

      it_behaves_like 'checkout progressbar have all elements'
    end

    context 'when addresses blocks' do
      let(:address_block) { complete_page.address_block }
      let(:address) { order.decorate.from_json_shipping_address }

      it_behaves_like 'address block have all elements'
    end

    context 'when cart items table' do
      let(:table_headers) { complete_page.cart_items_table.table_headers }
      let(:cart_item_block) { complete_page.cart_items_table.cart_items.first }
      let(:decorated_cart_item) { order.cart_items.first.decorate }

      it_behaves_like 'cart items table have all elements'
    end

    context 'when order summary table' do
      let(:order_summary) { complete_page.order_summary_table }

      it_behaves_like 'order summary block have all elements'

      it 'have shipping amount' do
        expect(order_summary).to have_shipping_title(text: I18n.t('checkout.order_summary_table.shipping'))
        expect(order_summary).to have_shipping_amount(text: order.shipping_method.decorate.price_with_currency)
      end
    end
  end

  describe 'click `back to store`' do
    context 'when `back to store` button click' do
      before { complete_page.back_to_store_button.click }

      it 'redirects to catalog page' do
        expect(complete_page).to have_current_path(books_path)
      end
    end
  end
end
