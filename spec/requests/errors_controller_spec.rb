# frozen_string_literal: true

RSpec.describe ErrorsController, type: :request do
  let(:error_book_id) { SecureRandom.uuid }

  describe 'handling RecordNotFound exceptions' do
    it 'renders the errors/404 template' do
      get "/books/#{error_book_id}"
      follow_redirect!
      expect(response).to render_template('errors/404')
    end
  end
end
