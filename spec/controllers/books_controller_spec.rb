# frozen_string_literal: true

RSpec.describe BooksController, type: :controller do
  describe '#index' do
    before { get :index }

    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders index template' do
      expect(response).to render_template(:catalog)
    end

    it 'assigns all categories to @categories' do
      expect(assigns(:categories)).to eq(Category.all)
    end
  end
end
