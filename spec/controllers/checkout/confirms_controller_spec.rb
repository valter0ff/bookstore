# frozen_string_literal: true

RSpec.describe Checkout::ConfirmsController, type: :controller do
  describe '#show' do
    context 'when user is not logged in' do
      it_behaves_like 'a redirect to checkout login page', :show
    end

    context 'when user is logged in' do
      before { order.confirm! }

      it_behaves_like 'a success render current page', :show
    end

    context 'when order`s step less then requested step' do
      it_behaves_like 'a redirect to root with `not authorized` alert', :show
    end

    context 'when order exists' do
      let(:user) { create(:user_account) }
      let(:order) { create(:order, user_account: user, step: :confirm) }
      let!(:cart_items) { create_list(:cart_item, rand(2..5), order: order, book: create(:book, :with_picture)) }

      before do
        sign_in(user)
        get :show
      end

      it 'assigns cart_items with included books and pictures', bullet: :skip do
        expect(assigns(:cart_items)).to eq(order.cart_items)
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user_account) }
    let!(:order) { create(:order, user_account: user, step: step) }

    context 'when order update success' do
      let(:params) { { id: order.id } }
      let(:step) { :confirm }

      before do |example|
        sign_in(user)
        put :update unless example.metadata[:skip_request]
      end

      it { is_expected.to redirect_to(checkout_complete_path(params)) }

      it 'calls Orders::ConfirmOrderService', skip_request: true do
        expect_any_instance_of(Orders::ConfirmOrderService).to receive(:call)
        put :update
      end
    end

    context 'when order update not success' do
      let(:error_message) { I18n.t('checkout.confirms.show.confirm_error') }
      let(:step) { :complete }

      before do
        sign_in(user)
        put :update
      end

      it { is_expected.to render_template(:show) }

      it 'sets flash now error' do
        expect(flash[:alert]).to eq(error_message)
      end
    end
  end
end
