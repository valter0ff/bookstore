# frozen_string_literal: true

RSpec.describe BooksController, type: :controller do
  let(:success_status) { 200 }
  let(:categories_count) { rand(2..10) }

  before { create_list(:category, categories_count) }

  describe '#index' do
    before { get :index }

    it 'has a 200 status code' do
      expect(response.status).to eq(success_status)
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end

    context 'when some category choosen' do
      let(:last_category) { Category.last }
      let(:other_category) { Category.first }

      before { get :index, params: { category_id: Category.last.id } }

      it 'assigns exact category' do
        expect(assigns(:category)).to eq(last_category)
      end

      it 'not assigns other category' do
        expect(assigns(:category)).not_to eq(other_category)
      end

      it 'assigns books of exact category' do
        expect(assigns(:books)).to eq(last_category.books)
      end
    end

    context 'when category not choosen' do
      before { get :index, params: { category_id: '' } }

      it 'assigns all categories to @categories' do
        expect(assigns(:categories)).to eq(Category.all)
      end
    end
  end

  describe '#show' do
    let(:book) { create :book, category: Category.first }

    before { get :show, params: { id: book.id } }

    it 'has a 200 status code' do
      expect(response.status).to eq(success_status)
    end

    it 'renders book_page template' do
      expect(response).to render_template(:show)
    end

    it 'assigns all categories to @categories' do
      expect(assigns(:book)).to eq(book)
    end
  end
end
