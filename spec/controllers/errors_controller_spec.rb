# frozen_string_literal: true

RSpec.describe ErrorsController, type: :controller do
  controller do
    def index
      raise ActiveRecord::RecordNotFound
    end
  end

  describe 'handling RecordNotFound exceptions' do
    it 'redirects to the /404 page' do
      get :index
      expect(response).to redirect_to('/404')
    end
  end
end
