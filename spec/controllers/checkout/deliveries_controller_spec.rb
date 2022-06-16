# frozen_string_literal: true

RSpec.describe Checkout::DeliveriesController, type: :controller do
  describe '#new' do
    let(:success_status) { 200 }

    context 'when user is not logged in' do
      before { get :new }

      it { is_expected.to redirect_to(new_checkout_session_path) }
    end

    context 'when user is logged in' do
      let(:user) { create(:user_account) }

      before do
        sign_in(user)
        create_list(:shipping_method, rand(2..10))
        get :new
      end

      it 'assigns all shipping methods to variable and decorates all of them' do
        expect(assigns(:shipping_methods)).to eq(ShippingMethod.all.decorate)
      end

      it { is_expected.to respond_with(success_status) }
      it { is_expected.to render_template(:new) }
    end
  end

  describe '#update' do
    let(:user) { create(:user_account) }
    let(:make_request) { post :update, params: params }
    let(:order) { controller.current_user.reload_current_order }

    before do
      sign_in(user)
      make_request
    end

    context 'when order update success' do
      let(:shipping_method) { create(:shipping_method) }
      let(:params) { { order: { shipping_method_id: shipping_method.id } } }
      let(:notice_message) { I18n.t('checkout.deliveries.new.shipping_method_saved') }

      it { is_expected.to redirect_to(new_checkout_payment_path) }
      it { is_expected.to set_flash[:notice].to(notice_message) }

      it 'updates shipping_method for order of current user' do
        expect(order.shipping_method).to eq(shipping_method)
      end
    end

    context 'when order update not success' do
      let(:alert_message) { I18n.t('checkout.deliveries.new.choose_method') }

      context 'with not choosen shipping method' do
        let(:params) { { order: { shipping_method_id: '' } } }

        it { is_expected.to render_template(:new) }

        it 'sets flash now alert' do
          expect(flash[:alert]).to eq(alert_message)
        end
      end

      context 'with not existing shipping method' do
        let(:params) { { order: { shipping_method_id: SecureRandom.uuid } } }

        it { is_expected.to render_template(:new) }

        it 'sets flash now alert' do
          expect(flash[:alert]).to eq(alert_message)
        end
      end
    end
  end
end
