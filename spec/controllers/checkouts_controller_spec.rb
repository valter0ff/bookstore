# frozen_string_literal: true

RSpec.describe CheckoutsController, type: :controller do
  let(:success_status) { 200 }

  describe '#login' do
    context 'when user is not logged in' do
      before { get :login }

      it { is_expected.to respond_with(success_status) }

      it 'renders login template' do
        expect(response).to render_template(:login)
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user_account) }

      before do
        sign_in(user)
        get :login
      end

      it { is_expected.to redirect_to(checkout_address_path) }
    end
  end

  describe '#address' do
    context 'when user is not logged in' do
      before { get :address }

      it { is_expected.to redirect_to(checkout_login_path) }
    end

    context 'when user is logged in' do
      let(:user) { create(:user_account) }

      before do
        sign_in(user)
        get :address
      end

      it { is_expected.to respond_with(success_status) }
      it { is_expected.to render_template(:address) }
    end
  end
end
