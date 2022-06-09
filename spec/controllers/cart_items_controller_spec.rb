# frozen_string_literal: true

RSpec.describe CartItemsController, type: :controller do
  let(:book) { create(:book) }
  let(:new_books_count) { rand(11..20) }
  let(:cart_item) { create(:cart_item, book: book, books_count: rand(2..10)) }
  let(:order) { create(:order, cart_items: [cart_item]) }
  let(:params) { { book_id: book.id, cart_item: { books_count: new_books_count } } }

  before do |example|
    request.session[:order_id] = order.id
    make_request unless example.metadata[:skip_request]
  end

  shared_examples 'not update cart item' do
    context 'when books count is blank' do
      let(:new_books_count) { '' }
      let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

      it 'doesn`t change cart item books count', skip_request: true do
        expect { make_request }.not_to change { cart_item.reload.books_count }
      end

      it 'assigns flash alert with corresponding error' do
        expect(flash[:alert]).to match(error_message)
      end
    end

    context 'when books count is not a number' do
      let(:new_books_count) { FFaker::Lorem.word }
      let(:error_message) { I18n.t('errors.messages.not_a_number') }

      it 'doesn`t change cart item books count', skip_request: true do
        expect { make_request }.not_to change { cart_item.reload.books_count }
      end

      it 'assigns flash alert with corresponding error' do
        expect(flash[:alert]).to match(error_message)
      end
    end

    context 'when books count less then zero' do
      let(:new_books_count) { rand(-10..-1) }
      let(:error_message) { I18n.t('errors.messages.greater_than', count: 0) }

      it 'doesn`t change cart item books count', skip_request: true do
        expect { make_request }.not_to change { cart_item.reload.books_count }
      end

      it 'assigns flash alert with corresponding error' do
        expect(flash[:alert]).to match(error_message)
      end
    end
  end

  describe '#create' do
    let(:make_request) { post :create, params: params }
    let(:success_message) { I18n.t('orders.book_added') }
    let(:redirect_status) { 302 }

    context 'when create new cart item in order' do
      let(:order) { create(:order) }

      it 'assignss cart item with correct book and attributes' do
        expect(assigns(:cart_item).book_id).to eq(book.id)
        expect(assigns(:cart_item).books_count).to eq(new_books_count)
        expect(assigns(:cart_item).order_id).to eq(order.id)
      end

      it 'creates new cart item in database', skip_request: true do
        expect { make_request }.to change(CartItem, :count).by(1)
      end

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to set_flash[:notice].to(success_message) }
    end

    context 'when card item with specified book_id exists in order' do
      it 'updates order cart item with books count from params', skip_request: true do
        expect { make_request }.to change { cart_item.reload.books_count }
      end

      it 'assigns current cart item to order`s cart item' do
        expect(assigns(:cart_item).id).to eq(cart_item.id)
      end

      it 'doesn`t create new cart item in database', skip_request: true do
        expect { make_request }.not_to change(CartItem, :count)
      end

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to set_flash[:notice].to(success_message) }
    end

    context 'when get wrong books count in params' do
      it_behaves_like 'not update cart item'
    end
  end

  describe '#update' do
    let(:make_request) { put :update, params: params }
    let(:success_message) { I18n.t('orders.order_updated') }
    let(:params) { { id: cart_item.id, cart_item: { books_count: new_books_count } } }

    context 'when cart item update successful' do
      it 'updates order cart item with books count from params' do
        expect(cart_item.reload.books_count).to eq(new_books_count)
      end

      it 'assigns flash notice with success message' do
        expect(flash[:notice]).to match(success_message)
      end
    end

    context 'when get wrong books count in params' do
      it_behaves_like 'not update cart item'
    end
  end

  describe '#increment_book' do
    let(:make_request) { put :increment_book, params: params }
    let(:params) { { id: cart_item.id } }

    it 'increments cart item books count by 1', skip_request: true do
      expect { make_request }.to change { cart_item.reload.books_count }.by(1)
    end
  end

  describe '#decrement_book' do
    let(:make_request) { put :decrement_book, params: params }
    let(:params) { { id: cart_item.id } }

    context 'when old books count larger than 1', skip_request: true do
      it 'reduces cart item books count by 1' do
        expect { make_request }.to change { cart_item.reload.books_count }.by(-1)
      end
    end

    context 'when old books count equals 1' do
      let(:cart_item) { create(:cart_item, book: book, books_count: 1) }
      let(:error_message) { I18n.t('errors.messages.greater_than', count: 0) }

      it 'doesn`t reduce books count', skip_request: true do
        expect { make_request }.not_to change { cart_item.reload.books_count }
      end

      it 'assigns flash alert with corresponding error' do
        expect(flash[:alert]).to match(error_message)
      end
    end
  end

  describe '#destroy' do
    let(:make_request) { delete :destroy, params: params }
    let(:params) { { id: cart_item.id } }

    it 'deletes current cart item', skip_request: true do
      expect { make_request }.to change(CartItem, :count).by(-1)
    end
  end
end
