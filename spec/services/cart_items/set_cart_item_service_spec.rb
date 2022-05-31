# frozen_string_literal: true

RSpec.describe CartItems::SetCartItemService do
  let(:current_cart_item) { described_class.call(order, params) }
  let(:order) { create(:order, cart_items: [cart_item1]) }
  let(:cart_item1) { create(:cart_item) }

  describe 'search cart item by id' do
    context 'when order includes cart item with such id' do
      let(:params) { { id: cart_item1.id } }

      it 'assigns founded object to current cart item' do
        expect(current_cart_item).to eq(cart_item1)
      end
    end

    context 'when order doesn`t include cart item with such id' do
      let(:params) { { id: nil } }

      it 'doesn`t assign any object to current cart item' do
        expect(current_cart_item).not_to eq(cart_item1)
      end
    end
  end

  describe 'search cart item by book_id' do
    context 'when order includes cart item with specified book id' do
      let(:params) { { book_id: cart_item1.book_id } }

      it 'assigns founded object to current cart item' do
        expect(current_cart_item).to eq(cart_item1)
      end
    end

    context 'when order doesn`t include cart item with specified book id' do
      let(:params) { { book_id: book.id } }
      let(:book) { create(:book) }

      it 'builds cart item with specified book id' do
        expect(current_cart_item).to be_a_new(CartItem)
        expect(current_cart_item.book_id).to eq(book.id)
        expect(current_cart_item.order_id).to eq(order.id)
      end
    end

    context 'when params doesn`t include id or book_id' do
      let(:params) { { id: nil } }

      it 'builds cart item with order_id of current order' do
        expect(current_cart_item).to be_a_new(CartItem)
        expect(current_cart_item.order_id).to eq(order.id)
      end
    end
  end
end
