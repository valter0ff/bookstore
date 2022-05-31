# frozen_string_literal: true

RSpec.describe Orders::SetOrderService do
  let(:order_service_instance) { described_class.new(user, session) }
  let(:current_order) { order_service_instance.instance_variable_get(:@order) }

  before { order_service_instance.call }

  RSpec.shared_context 'with session order' do
    let(:cart_item1) { create(:cart_item, books_count: books_count1) }
    let(:cart_item2) { create(:cart_item) }
    let(:books_count1) { rand(1..10) }
    let(:session_order) { create(:order, cart_items: [cart_item1, cart_item2]) }
    let(:session) { { order_id: session_order.id } }
  end

  describe 'current_user present' do
    context 'when user already have order' do
      let(:cart_item4) { create(:cart_item) }
      let(:user) { create(:user_account, orders: [user_order]) }

      context 'when session_order exists' do
        let(:current_session) { order_service_instance.instance_variable_get(:@session) }
        let(:cart_item3) { create(:cart_item, book_id: cart_item1.book_id, books_count: books_count3) }
        let(:books_count3) { rand(1..10) }
        let(:user_order) { create(:order, cart_items: [cart_item3, cart_item4]) }
        let(:current_order_book_ids) { current_order.cart_items.pluck(:book_id) }
        let(:current_order_first_item_books_count) { current_order.cart_items.first.books_count }

        include_context 'with session order'

        it 'assigns user_order to current_order' do
          expect(current_order.id).to eq(user_order.id)
        end

        it 'updates current order with session order' do
          expect(current_order_book_ids).to include(session_order.cart_items.first.book_id)
          expect(current_order_book_ids).to include(session_order.cart_items.last.book_id)
        end

        it 'summarizes books_count in cart items with the same book_id' do
          expect(current_order_first_item_books_count).to eq(books_count1 + books_count3)
        end

        it 'deletes order_id from session' do
          expect(current_session).not_to have_key(:order_id)
        end
      end

      context 'when session_order doesn`t exist' do
        let(:session) { { order_id: nil } }
        let(:cart_item2) { build(:cart_item) }
        let(:user_order) { create(:order, cart_items: [cart_item4]) }

        it 'assigns user_order to current_order' do
          expect(current_order).to eq(user_order)
        end
      end
    end

    context 'when user doesn`t have order yet' do
      let(:user) { create(:user_account) }

      context 'when session_order exists' do
        include_context 'with session order'

        it 'assigns session_order to current order' do
          expect(current_order).to eq(session_order)
        end
      end

      context 'when session_order doesn`t exist' do
        let(:session) { { order_id: nil } }
        let(:current_session) { order_service_instance.instance_variable_get(:@session) }

        it 'build new Order instance and assigns it to user' do
          expect(current_order.user_account_id).to eq(user.id)
          expect(current_order).to be_a(Order)
        end

        it 'deletes order_id from session' do
          expect(current_session).not_to have_key(:order_id)
        end
      end
    end
  end

  describe 'current_user not present' do
    let(:user) { nil }

    context 'when session_order exists' do
      include_context 'with session order'

      it 'assigns session_order to current order' do
        expect(current_order).to eq(session_order)
      end
    end

    context 'when session_order doesn`t exist' do
      let(:session) { { order_id: nil } }
      let(:current_session) { order_service_instance.instance_variable_get(:@session) }

      it 'creates new Order and assigns it to current order' do
        expect(current_order).to be_a(Order)
      end

      it 'assignns current order id to session' do
        expect(current_session[:order_id]).to eq(current_order.id)
      end
    end
  end
end
