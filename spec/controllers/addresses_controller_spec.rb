# frozen_string_literal: true

RSpec.describe AddressesController, type: :controller do
  let(:success_status) { 200 }
  let(:user) { create(:user_account) }
  
  before { |example| sign_in(user) unless example.metadata[:skip_sign_in] }

  describe '#new' do
    before { get :new }
    
    context 'with success response' do
      it { is_expected.to respond_with(success_status) }
      it { is_expected.to render_template(:new) }

      it 'assigns address resource to be a subclass of Address' do
        expect(assigns(:billing_address)).to be_an_instance_of(BillingAddress)
        expect(assigns(:shipping_address)).to be_an_instance_of(ShippingAddress)
        expect(assigns(:billing_address)).to be_kind_of(Address)
        expect(assigns(:shipping_address)).to be_kind_of(Address)
      end

      it 'assigns billing and shipping addresses to separate objects' do
        expect(assigns(:billing_address)).not_to eq(assigns(:shipping_address))
      end
    end

    context 'when user is not authenticated', skip_sign_in: true do
      it { is_expected.to redirect_to('/users/login') }
      it { is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated')) }
    end
  end

  describe '#create' do
    let(:make_request) { post :create, params: { :address => address_params } }
    let(:redirect_status) { 302 }
    
    before { |example| make_request unless example.metadata[:skip_request] }

    context 'when address created' do
      let(:address_params) { attributes_for(:address, user_account_id: user.id) }

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to redirect_to(action: :new) }
      it { is_expected.to set_flash[:notice].to(I18n.t('addresses.create.success')) }

      it 'creates new address', skip_request: true do
        expect { make_request }.to change(Address, :count).by(1)
      end
    end
  end
end
