# frozen_string_literal: true

RSpec.describe CartsController, type: :controller do
  let(:success_status) { 200 }
  let(:order) { create(:order) }

  before do
    request.session[:order_id] = order.id
    get :show
  end

  describe '#show' do
    it { is_expected.to respond_with(success_status) }

    it 'decorates current order' do
      expect(assigns(:order)).to eq(order.decorate)
    end
  end
end
