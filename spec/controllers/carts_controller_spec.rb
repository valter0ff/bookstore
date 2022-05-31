# frozen_string_literal: true

RSpec.describe CartsController, type: :controller do
  let(:success_status) { 200 }
  let(:order) { create(:order, coupon: nil) }

  before do |_example|
    request.session[:order_id] = order.id
    make_request
  end

  describe '#show' do
    let(:make_request) { get :show }

    it { is_expected.to respond_with(success_status) }

    it 'assigns current order with decorator' do
      expect(assigns(:order)).to eq(order.decorate)
    end
  end

  describe '#update' do
    let(:redirect_status) { 302 }
    let(:make_request) { put :update, params: params }
    let(:params) { { order: { coupon: { code: code } } } }
    let(:updated_order) { Order.find_by(id: order.id) }

    context 'when coupon code exists' do
      let(:code) { coupon.code }

      context 'when coupon is active' do
        let(:coupon) { create(:coupon) }
        let(:success_message) { I18n.t('carts.show.coupon_applied') }

        it 'applies coupon to current order' do
          expect(updated_order.coupon).to eq(coupon)
        end

        it { is_expected.to respond_with(redirect_status) }
        it { is_expected.to redirect_to(cart_path) }
        it { is_expected.to set_flash[:notice].to(success_message) }
      end

      context 'when coupon is used' do
        let(:error_message) { I18n.t('carts.show.coupon_rejected') }
        let(:coupon) { create(:coupon, status: :used) }

        it 'doesn`t apply coupon to current order' do
          expect(updated_order.coupon).to be_nil
          expect(updated_order.coupon).not_to eq(coupon)
        end

        it { is_expected.to respond_with(redirect_status) }
        it { is_expected.to redirect_to(cart_path) }
        it { is_expected.to set_flash[:alert].to(error_message) }
      end
    end

    context 'when coupon code doesn`t exist' do
      let(:code) { FFaker::Lorem.word }
      let(:error_message) { I18n.t('carts.show.coupon_rejected') }

      it 'doesn`t apply coupon to current order' do
        expect(updated_order.coupon).to be_nil
      end

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to redirect_to(cart_path) }
      it { is_expected.to set_flash[:alert].to(error_message) }
    end
  end
end
