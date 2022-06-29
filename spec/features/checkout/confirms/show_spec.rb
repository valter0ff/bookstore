# frozen_string_literal: true

RSpec.describe 'Checkout::Confirms->Show', type: :feature do
  let(:confirm_page) { Pages::Checkout::Confirms::Show.new }
  let(:user) { create(:user_account, use_billing_address: true) }
  let!(:address) { create(:billing_address, user_account: user) }
  let!(:order) { create(:order, :confirm, user_account: user) }
  let!(:shipping_method) { create(:shipping_method, orders: [order]) }
  let!(:credit_card) { create(:credit_card, order: order) }
  let!(:cart_items) { create_list(:cart_item, rand(2..5), order: order) }

  before do
    sign_in(user)
    confirm_page.load
  end

  describe 'loading page elements' do
    context 'when whole page' do
      it 'all elements present' do
        expect(confirm_page).to have_page_title(text: I18n.t('checkout.shared.general_title'))
        expect(confirm_page).to have_billing_address_title(text: I18n.t('addresses.new.billing_title'))
        expect(confirm_page).to have_shipping_address_title(text: I18n.t('addresses.new.shipping_title'))
        expect(confirm_page).to have_shipping_method_title(text: I18n.t('checkout.confirms.show.shipments'))
        expect(confirm_page).to have_shipping_method_name(text: shipping_method.name)
        expect(confirm_page).to have_payment_title(text: I18n.t('checkout.confirms.show.payment_information'))
        expect(confirm_page).to have_credit_card_number(text: credit_card.decorate.masked_number)
        expect(confirm_page).to have_credit_card_expiry_date(text: credit_card.decorate.expiry_date_full_year)
        expect(confirm_page).to have_edit_links(text: I18n.t('checkout.confirms.show.edit'))
        expect(confirm_page).to have_order_summary_title(text: I18n.t('carts.show.order_summary'))
        expect(confirm_page).to have_place_order_button
        expect(confirm_page.place_order_button.value).to eq(I18n.t('checkout.confirms.show.place_order'))
      end
    end

    context 'when checkout progress bar' do
      let(:progress_bar) { confirm_page.checkout_progress_bar }

      it_behaves_like 'checkout progressbar have all elements'
    end

    context 'when addresses blocks' do
      let(:address_block) { confirm_page.address_block.first }

      it 'have all elements with correct text' do
        expect(address_block).to have_address_full_name(text: "#{address.first_name} #{address.last_name}")
        expect(address_block).to have_address_address(text: address.address)
        expect(address_block).to have_address_city_zip(text: "#{address.city} #{address.zip}")
        expect(address_block).to have_address_country(text: address.country_name)
        expect(address_block).to have_address_phone(text: "#{I18n.t('checkout.address.phone')} #{address.phone}")
      end
    end

    context 'when cart items table' do
      let(:table_headers) { confirm_page.cart_items_table.table_headers }
      let(:cart_item) { confirm_page.cart_items_table.cart_items.first }

      it 'all headers present' do
        expect(table_headers).to have_book_label(text: I18n.t('checkout.cart_items.book'))
        expect(table_headers).to have_price_label(text: I18n.t('checkout.cart_items.price'))
        expect(table_headers).to have_quantity_label(text: I18n.t('checkout.cart_items.quantity'))
        expect(table_headers).to have_subtotal_label(text: I18n.t('checkout.cart_items.subtotal'))
      end

      it 'all elements present' do
        expect(cart_item).to have_book_image
        expect(cart_item).to have_book_title
        expect(cart_item).to have_book_price
        expect(cart_item).to have_book_quantity
        expect(cart_item).to have_subtotal_price
      end
    end

    context 'when order summary table' do
      let(:order_summary) { confirm_page.order_summary_table }

      it_behaves_like 'order summary block have all elements'

      it 'have shipping amount' do
        expect(order_summary).to have_shipping_title(text: I18n.t('checkout.order_summary_table.shipping'))
        expect(order_summary).to have_shipping_amount
      end
    end
  end
end
