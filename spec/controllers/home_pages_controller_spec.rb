# frozen_string_literal: true

RSpec.describe HomePagesController do
  describe '#index' do
    let!(:categories) { create_list(:category, rand(1..10)) }

    context 'when page load' do
      before { get :index }

      it 'has a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'renders index template' do
        expect(response).to render_template(:index)
      end

      it 'does not render a different template' do
        expect(response).not_to render_template(:show)
      end

      it 'assigns all categories to @categories' do
        expect(assigns(:categories)).to eq(Category.all)
      end

      it 'not assigns all books to @categories' do
        expect(assigns(:categories)).not_to eq(Book.all)
      end
    end

    context 'when shows best sellers and latest books', bullet: :skip do
      let(:user) { create(:user_account) }
      let(:orders) { create_list(:order, rand(2..5), :confirm, :filled, user_account: user) }
      let(:expected_best_sellers) { Book.order(sales_count: :desc).limit(Constants::Shared::BEST_SELLERS_COUNT) }
      let(:expected_latest_books) { Book.order(created_at: :desc).limit(Constants::Shared::LATEST_BOOKS_COUNT) }

      before do
        orders.each { |order| Orders::ConfirmOrderService.call(user, order) }
        get :index
      end

      it 'assigns 4 books with max sales count to @best_sellers' do
        expect(assigns(:best_sellers)).to eq(expected_best_sellers)
        expect(assigns(:best_sellers)).not_to eq(Book.all)
      end

      it 'returns best sellers books in correct order' do
        expect(assigns(:best_sellers)[0].sales_count).to be >= assigns(:best_sellers)[1].sales_count
      end

      it 'assigns 3 last added books to @latest_books' do
        expect(assigns(:latest_books)).to eq(expected_latest_books)
        expect(assigns(:latest_books)).not_to eq(Book.all)
      end

      it 'returns latest books in correct order' do
        expect(assigns(:latest_books)[0].created_at).to be > assigns(:latest_books)[1].created_at
      end
    end
  end
end
