# frozen_string_literal: true

RSpec.describe OrdersController, type: :controller do
  describe '#index' do
    context 'when user is not logged in' do
      before { get :index }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'when user is logged in' do
      let(:user) { create(:user_account) }
      let!(:orders) { create_list(:order, rand(2..5), :filled, :completed, user_account: user) }
      let(:success_status) { 200 }

      before do
        sign_in(user)
        get :index
      end

      it { is_expected.to respond_with(success_status) }
      it { is_expected.to render_template(:index) }

      it 'assigns user`s orders with `complete` state to @orders', bullet: :skip do
        expect(assigns(:orders).count).to eq(orders.count)
      end
    end
  end

  describe '#show' do
    let(:user) { create(:user_account) }
    let!(:order) { create(:order, :filled, :completed, user_account: user) }
    let(:success_status) { 200 }
    let(:params) { { id: order.id } }

    before do
      sign_in(user)
      get :show, params: params
    end

    it { is_expected.to respond_with(success_status) }
    it { is_expected.to render_template(:show) }

    it 'decorates current order' do
      expect(assigns(:current_order)).to eq(order.decorate)
    end

    it 'assigns cart_items variable', bullet: :skip do
      expect(assigns(:cart_items)).to eq(order.cart_items)
    end
  end

  describe '#apply_coupon' do
    let(:apply_coupon_on_order) { put :apply_coupon, params: params }
    let(:redirect_status) { 302 }
    let(:params) { { id: order.id, order: { coupon: { code: code } } } }
    let(:order) { create(:order, coupon: nil) }

    before do
      request.session[:order_id] = order.id
      apply_coupon_on_order
    end

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
