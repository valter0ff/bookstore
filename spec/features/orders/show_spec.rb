# frozen_string_literal: true

RSpec.describe 'Orders->Show', type: :feature do
  let(:show_order_page) { Pages::Orders::Show.new }
  let(:user) { create(:user_account) }
  let!(:order) { create(:order, :filled, :completed, user_account: user) }

  before do
    sign_in(user)
    show_order_page.load(id: order.id)
  end

  describe 'loading page elements' do
    context 'when whole page' do
      it 'all elements present' do
        expect(show_order_page).to have_page_title(text: I18n.t('orders.show.order_number', number: order.number))
        expect(show_order_page).to have_billing_address_title(text: I18n.t('addresses.new.billing_title'))
        expect(show_order_page).to have_shipping_address_title(text: I18n.t('addresses.new.shipping_title'))
        expect(show_order_page).to have_shipping_method_title(text: I18n.t('orders.show.shipments'))
        expect(show_order_page).to have_shipping_method_name(text: order.shipping_method.name)
        expect(show_order_page).to have_payment_title(text: I18n.t('orders.show.payment_information'))
        expect(show_order_page).to have_credit_card_number(text: order.credit_card.decorate.masked_number)
        expect(show_order_page).to have_credit_card_expiry_date(text: order.credit_card.decorate.expiry_date_full_year)
        expect(show_order_page).to have_order_summary_title(text: I18n.t('carts.show.order_summary'))
      end
    end

    context 'when addresses blocks' do
      let(:address_block) { show_order_page.address_block.first }
      let(:address) { order.decorate.from_json_shipping_address }

      it_behaves_like 'address block have all elements'
    end

    context 'when cart items table' do
      let(:table_headers) { show_order_page.cart_items_table.table_headers }
      let(:cart_item_block) { show_order_page.cart_items_table.cart_items.first }
      let(:decorated_cart_item) { order.cart_items.first.decorate }

      it_behaves_like 'cart items table have all elements'
    end

    context 'when order summary table' do
      let(:order_summary) { show_order_page.order_summary_table }

      it_behaves_like 'order summary block have all elements'

      it 'have shipping amount' do
        expect(order_summary).to have_shipping_title(text: I18n.t('checkout.order_summary_table.shipping'))
        expect(order_summary).to have_shipping_amount(text: order.shipping_method.decorate.price_with_currency)
      end
    end
  end
end
