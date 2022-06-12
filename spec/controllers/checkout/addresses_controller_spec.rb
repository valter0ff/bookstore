# frozen_string_literal: true

RSpec.describe Checkout::AddressesController, type: :controller do
  let(:success_status) { 200 }

   describe '#new' do
    context 'when user is not logged in' do
      before { get :new }

      it { is_expected.to redirect_to(new_checkout_session_path) }
    end

    context 'when user is logged in' do
      let(:user) { create(:user_account) }

      before do
        sign_in(user)
        get :new
      end

      it { is_expected.to respond_with(success_status) }
      it { is_expected.to render_template(:new) }
    end
  end
end
