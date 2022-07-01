# frozen_string_literal: true

RSpec.describe Checkout::CompletesController, type: :controller do
  describe '#show' do
    context 'when user is not logged in' do
      before { get :show }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'when user is logged in' do
      let(:user) { create(:user_account, use_billing_address: true) }
      let(:order) { create(:order, :filled, user_account: user, step: step) }
      let!(:address) { create(:billing_address, user_account: user) }

      context 'when order step `complete`', bullet: :skip do
        let(:step) { :complete }

        before do
          Orders::ConfirmOrderService.call(user, order)
          sign_in(user)
          get :show, params: { id: order.id }
        end

        it_behaves_like 'a success render current page', :show

        it 'decorates current order' do
          expect(assigns(:order)).to eq(order.decorate)
        end

        it 'assigns cart_items variable' do
          expect(assigns(:cart_items)).to eq(order.cart_items)
        end
      end

      context 'when order`s step not complete' do
        let(:step) { :payment }

        before do
          sign_in(user)
          get :show, params: { id: order.id }
        end

        it_behaves_like 'a redirect to root with `not authorized` alert'
      end
    end
  end
end
