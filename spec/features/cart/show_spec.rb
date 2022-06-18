# frozen_string_literal: true

RSpec.describe 'Cart->Show', type: :feature do
  let(:cart_page) { Pages::Cart::Show.new }
  let(:cart_item) { create(:cart_item, books_count: books_count) }
  let(:books_count) { rand(1..10) }

  before do
    page.set_rack_session(order_id: cart_item.order_id)
    cart_page.load
  end

  describe 'load page elements' do
    let(:cart_items_table) { cart_page.cart_items_table }

    it 'page elements present' do
      expect(cart_page).to have_cart_icon
      expect(cart_page).to have_checkout_button(text: I18n.t('carts.show.checkout'))
    end

    context 'when cart items table headers' do
      let(:table_headers) { cart_items_table.table_headers }

      it 'all elements present' do
        expect(table_headers).to have_product_header(text: I18n.t('carts.show.product'))
        expect(table_headers).to have_price_header(text: I18n.t('carts.show.price'))
        expect(table_headers).to have_quantity_header(text: I18n.t('carts.show.quantity'))
        expect(table_headers).to have_subtotal_header(text: I18n.t('carts.show.subtotal'))
      end
    end

    context 'when cart item block' do
      let(:cart_item_block) { cart_items_table.cart_item.first }

      it 'all elements present' do
        expect(cart_item_block).to have_product_image
        expect(cart_item_block).to have_product_title
        expect(cart_item_block).to have_product_price
        expect(cart_item_block).to have_decrement_button
        expect(cart_item_block).to have_quantity_input
        expect(cart_item_block).to have_increment_button
        expect(cart_item_block).to have_subtotal_price
        expect(cart_item_block).to have_delete_button
      end
    end

    context 'when coupon form' do
      let(:coupon_form) { cart_page.coupon_form }

      it 'all elements present' do
        expect(coupon_form).to have_code_input_label(text: I18n.t('carts.show.enter_coupon'))
        expect(coupon_form).to have_code_input_field
        expect(coupon_form).to have_submit_button
      end
    end

    context 'when order summary block' do
      let(:order_summary) { cart_page.order_summary }

      it 'order summary title present' do
        expect(order_summary).to have_order_summary_title(text: I18n.t('carts.show.order_summary'))
      end

      it_behaves_like 'order summary block have all elements'
    end
  end

  describe 'success on update books count' do
    let(:cart_item_block) { cart_page.cart_items_table.cart_item.first }

    shared_examples 'success request', js: true do
      let(:notice_message) { I18n.t('orders.order_updated') }

      it 'set notice message to flash' do
        expect(cart_page).to have_flash_notice
        expect(cart_page.flash_notice.text).to match(notice_message)
      end
    end

    context 'when decrement button click and books count larger than 1' do
      let(:books_count) { rand(2..10) }
      let(:new_books_count) { cart_item.books_count - 1 }

      before { cart_item_block.decrement_button.click }

      it_behaves_like 'success request'
    end

    context 'when increment button click' do
      let(:new_books_count) { cart_item.books_count + 1 }

      before { cart_item_block.increment_button.click }

      it_behaves_like 'success request'
    end

    context 'when quantity input change and books count larger than 1' do
      let(:new_books_count) { rand(11..20) }

      before do
        cart_item_block.quantity_input.set(new_books_count)
        cart_item_block.quantity_input.native.send_keys(:enter)
      end

      it_behaves_like 'success request'
    end
  end

  describe 'not success on update books count' do
    let(:cart_item_block) { cart_page.cart_items_table.cart_item.first }

    shared_examples 'failed request', js: true do
      it 'set error message to flash' do
        expect(cart_page).to have_flash_alert
        expect(cart_page.flash_alert.text).to match(error_message)
      end
    end

    context 'when decrement button click and books count equals 1' do
      let(:books_count) { 1 }
      let(:error_message) { I18n.t('errors.messages.greater_than', count: 0) }

      before { cart_item_block.decrement_button.click }

      it_behaves_like 'failed request'
    end

    context 'when quantity input change' do
      before do
        cart_item_block.quantity_input.set(new_books_count)
        cart_item_block.quantity_input.native.send_keys(:enter)
      end

      context 'when books count less than 1' do
        let(:new_books_count) { rand(-10..0) }
        let(:error_message) { I18n.t('errors.messages.greater_than', count: 0) }

        it_behaves_like 'failed request'
      end

      context 'when books count blank' do
        let(:new_books_count) { '' }
        let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

        it_behaves_like 'failed request'
      end

      context 'when books count isn`t a number' do
        let(:new_books_count) { FFaker::Lorem.word }
        let(:error_message) { I18n.t('errors.messages.not_a_number') }

        it_behaves_like 'failed request'
      end
    end
  end

  describe 'delete cart item' do
    let(:cart_items_block) { cart_page.cart_items_table.cart_item }
    let(:delete_cart_item) { cart_page.cart_items_table.cart_item.last.delete_button.click }
    let(:cart_items_count) { rand(1..10) }
    let(:order) { create(:order, cart_items: create_list(:cart_item, cart_items_count)) }

    before do
      page.set_rack_session(order_id: order.id)
      cart_page.load
    end

    it 'removes cart item block from page', js: true do
      accept_confirm { delete_cart_item }
      expect(cart_items_block.count).to eq(cart_items_count - 1)
    end

    it 'remove cart item from database' do
      expect { delete_cart_item }.to change(CartItem, :count).by(-1)
    end
  end

  describe 'apply coupon' do
    let(:coupon_form) { cart_page.coupon_form }
    let(:order) { cart_item.order.reload.decorate }
    let(:coupon) { create(:coupon) }
    let(:order_summary) { cart_page.order_summary }

    before do
      coupon_form.apply_coupon(coupon.code)
    end

    it 'updates order summary information' do
      expect(order_summary.discount.text).to eq(order.discount)
      expect(order_summary.order_total.text).to eq(order.total_price)
    end
  end
end
