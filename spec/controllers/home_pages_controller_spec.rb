# frozen_string_literal: true

RSpec.describe HomePagesController do
  describe '#index' do
    before do
      create_list(:category, rand(1..10))
      get :index
    end

    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns all categories to @categories' do
      expect(assigns(:categories)).to eq(Category.all)
    end

    it 'not assigns all books to @categories' do
      expect(assigns(:categories)).not_to eq(Book.all)
    end
  end
end
