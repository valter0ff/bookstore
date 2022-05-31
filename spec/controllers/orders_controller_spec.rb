# frozen_string_literal: true

RSpec.describe OrdersController, type: :controller do
  let(:order) { create(:order, coupon: nil) }

  before do
    request.session[:order_id] = order.id
    make_request
  end

  describe '#apply_coupon' do
    let(:redirect_status) { 302 }
    let(:make_request) { put :apply_coupon, params: params }
    let(:params) { { id: order.id, order: { coupon: { code: code } } } }

    context 'when coupon code exists' do
      let(:code) { coupon.code }

      context 'when coupon is active' do
        let(:coupon) { create(:coupon) }
        let(:success_message) { I18n.t('orders.coupon_applied') }

        it 'applies coupon to current order' do
          expect(order.reload.coupon).to eq(coupon)
        end

        it { is_expected.to respond_with(redirect_status) }
        it { is_expected.to redirect_to(cart_path) }
        it { is_expected.to set_flash[:notice].to(success_message) }
      end

      context 'when coupon is used' do
        let(:error_message) { I18n.t('orders.coupon_rejected') }
        let(:coupon) { create(:coupon, status: :used) }

        it 'doesn`t apply coupon to current order' do
          expect(order.reload.coupon).to be_nil
          expect(order.reload.coupon).not_to eq(coupon)
        end

        it { is_expected.to respond_with(redirect_status) }
        it { is_expected.to redirect_to(cart_path) }
        it { is_expected.to set_flash[:alert].to(error_message) }
      end
    end

    context 'when coupon code doesn`t exist' do
      let(:code) { FFaker::Lorem.word }
      let(:error_message) { I18n.t('orders.coupon_rejected') }

      it 'doesn`t apply coupon to current order' do
        expect(order.reload.coupon).to be_nil
      end

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to redirect_to(cart_path) }
      it { is_expected.to set_flash[:alert].to(error_message) }
    end
  end
end
