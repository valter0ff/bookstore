# frozen_string_literal: true

RSpec.describe Checkout::AddressesController, type: :controller do
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
        get :new
      end

      it { is_expected.to respond_with(success_status) }
      it { is_expected.to render_template(:new) }
    end
  end

  describe '#update' do
    let(:user) { create(:user_account) }
    let(:make_request) { post :update, params: params }
    let(:params) do
      { user_account: { billing_address_attributes: billing_attrs,
                        shipping_address_attributes: shipping_attrs } }
    end

    before { sign_in(user) }

    context 'when request successful' do
      let(:billing_attrs) { attributes_for(:billing_address) }
      let(:shipping_attrs) { attributes_for(:shipping_address) }
      let(:notice_message) { I18n.t('checkout.addresses.new.addresses_saved') }

      context 'when user doesn`t have addresses yet' do
        before { |example| make_request unless example.metadata[:skip_request] }

        it { is_expected.to redirect_to(new_checkout_delivery_path) }
        it { is_expected.to set_flash[:notice].to(notice_message) }

        it_behaves_like 'address update success' do
          let(:address) { user.reload.billing_address }
          let(:request_params) { billing_attrs }
        end

        it_behaves_like 'address update success' do
          let(:address) { user.reload.shipping_address }
          let(:request_params) { shipping_attrs }
        end

        it 'creates both new addresses', skip_request: true do
          expect { make_request }.to change(Address, :count).by(2)
        end
      end

      context 'when user already have addresses' do
        before do |example|
          create(:billing_address, user_account: user)
          create(:shipping_address, user_account: user)
          make_request unless example.metadata[:skip_request]
        end

        it_behaves_like 'address update success' do
          let(:address) { user.reload.billing_address }
          let(:request_params) { billing_attrs }
        end

        it_behaves_like 'address update success' do
          let(:address) { user.reload.shipping_address }
          let(:request_params) { shipping_attrs }
        end

        it 'doesn`t create new addresses in database', skip_request: true do
          expect { make_request }.not_to change(Address, :count)
        end
      end

      context 'when use_billing_address checkbox active' do
        let(:params) do
          { user_account: { billing_address_attributes: billing_attrs,
                            shipping_address_attributes: shipping_attrs,
                            use_billing_address: true } }
        end

        before { make_request }

        it_behaves_like 'address update success' do
          let(:address) { user.reload.billing_address }
          let(:request_params) { billing_attrs }
        end

        it 'doesn`t update shipping address' do
          expect(user.reload.shipping_address).to be_nil
        end
      end
    end

    context 'when request failed' do
      let(:billing_attrs) { attributes_for(:billing_address, city: FFaker::Internet.email) }
      let(:shipping_attrs) { attributes_for(:shipping_address, zip: '') }
      let(:errors_path) { %w[activerecord errors models address attributes] }
      let(:format_error_message) { I18n.t('city.invalid', scope: errors_path) }
      let(:blank_error_message) { I18n.t('activerecord.errors.messages.blank') }

      before { |example| make_request unless example.metadata[:skip_request] }

      it { is_expected.to render_template(:new) }

      it 'doesn`t update user`s addresses' do
        user.reload
        expect(user.billing_address).to be_nil
        expect(user.shipping_address).to be_nil
      end

      it 'doesn`t create new addresses in database', skip_request: true do
        expect { make_request }.not_to change(Address, :count)
      end

      it 'assigns user addresses attributes with corresponding error' do
        expect(assigns(:current_user).errors['billing_address.city'].first).to match(format_error_message)
        expect(assigns(:current_user).errors['shipping_address.zip'].first).to match(blank_error_message)
      end
    end
  end
end
