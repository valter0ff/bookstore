# frozen_string_literal: true

RSpec.describe Checkout::DeliveriesController, type: :controller do
  describe '#edit' do
    context 'when user is not logged in' do
      before { get :edit }

      it_behaves_like 'a redirect to checkout login page'
    end

    context 'when user exists' do
      let(:user) { create(:user_account) }
      let!(:order) { create(:order, user_account: user, step: step) }

      before do
        sign_in(user)
        get :edit
      end

      context 'when user is logged in' do
        let(:step) { :delivery }

        it_behaves_like 'a success render current page', :edit
      end

      context 'when order`s step less then requested step' do
        let(:step) { :address }

        it_behaves_like 'a redirect to root with `not authorized` alert'
      end

      context 'when shipping methods exists' do
        let(:step) { :delivery }
        let!(:shipping_methods) { create_list(:shipping_method, rand(2..10)) }

        it 'assigns all shipping methods to variable and decorates all of them' do
          expect(assigns(:shipping_methods)).to eq(ShippingMethod.all.decorate)
        end
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user_account) }
    let(:make_request) { put :update, params: params }
    let(:current_order) { controller.current_user.reload_current_order }
    let!(:order) { create(:order, :delivery, user_account: user) }

    before do
      sign_in(user)
      make_request
    end

    context 'when order update success' do
      let(:shipping_method) { create(:shipping_method) }
      let(:params) { { order: { shipping_method_id: shipping_method.id } } }
      let(:success_message) { I18n.t('checkout.deliveries.edit.shipping_method_saved') }

      it { is_expected.to redirect_to(edit_checkout_payment_path) }
      it { is_expected.to set_flash[:notice].to(success_message) }

      it 'updates shipping_method for order of current user' do
        expect(current_order.shipping_method).to eq(shipping_method)
      end
    end

    context 'when order update not success' do
      let(:error_message) { I18n.t('checkout.deliveries.edit.choose_method') }

      context 'with not choosen shipping method' do
        let(:params) { { order: { shipping_method_id: '' } } }

        it { is_expected.to render_template(:edit) }

        it 'sets flash now error' do
          expect(flash[:alert]).to eq(error_message)
        end
      end

      context 'with not existing shipping method' do
        let(:params) { { order: { shipping_method_id: SecureRandom.uuid } } }

        it { is_expected.to render_template(:edit) }

        it 'sets flash now error' do
          expect(flash[:alert]).to eq(error_message)
        end
      end
    end
  end
end
