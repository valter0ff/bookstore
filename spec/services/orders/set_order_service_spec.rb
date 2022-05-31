# frozen_string_literal: true

RSpec.describe Orders::SetOrderService do
  let(:order_service_instance) { described_class.new(user, session) }
  let(:current_order) { order_service_instance.instance_variable_get(:@order) }
  let(:current_session) { order_service_instance.instance_variable_get(:@session) }

  before { order_service_instance.call }

  RSpec.shared_context 'with session order' do
    let(:first_cart_item) { create(:cart_item) }
    let(:session_order) { create(:order, cart_items: [first_cart_item]) }
    let(:session) { { order_id: session_order.id } }
  end

  describe 'current_user present' do
    context 'when user already have order' do
      let(:second_cart_item) { create(:cart_item) }
      let(:user) { create(:user_account, orders: [user_order]) }
      let(:user_order) { create(:order, cart_items: [second_cart_item]) }

      context 'when session_order exists' do
        let(:current_order_book_ids) { current_order.cart_items.pluck(:book_id) }

        include_context 'with session order'

        it 'assigns user_order to current_order' do
          expect(current_order.id).to eq(user_order.id)
        end

        it 'updates current order with session order' do
          expect(current_order_book_ids).to include(first_cart_item.book_id)
          expect(current_order_book_ids).to include(second_cart_item.book_id)
        end

        it 'deletes order_id from session' do
          expect(current_session).not_to have_key(:order_id)
        end
      end

      context 'when session and user orders cart items book id is the same' do
        let(:second_cart_item) { create(:cart_item, book_id: first_cart_item.book_id) }
        let!(:books_count_sum) { first_cart_item.books_count + second_cart_item.books_count }

        it 'summarizes books_count in cart items' do
          expect(second_cart_item.reload.books_count).to eq(books_count_sum)
        end
      end

      context 'when session_order doesn`t exist' do
        let(:session) { { order_id: nil } }

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

      it 'creates new Order and assigns it to current order' do
        expect(current_order).to be_a(Order)
      end

      it 'assignns current order id to session' do
        expect(current_session[:order_id]).to eq(current_order.id)
      end
    end
  end
end
