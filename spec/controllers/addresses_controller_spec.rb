# frozen_string_literal: true

RSpec.describe AddressesController, type: :controller do
  let(:success_status) { 200 }
  let(:redirect_status) { 302 }
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
    let(:make_request) { post :create, params: { address: address_params } }

    before { |example| make_request unless example.metadata[:skip_request] }

    context 'when address created' do
      let(:address_params) { attributes_for(:billing_address, user_account_id: user.id) }

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to redirect_to(action: :new) }
      it { is_expected.to set_flash[:notice].to(I18n.t('addresses.create.success')) }

      it 'assigns address variable to user`s corresponding address' do
        user.reload
        expect(assigns(:address)).to eq(user.billing_address)
      end

      it 'creates new address', skip_request: true do
        expect { make_request }.to change(Address, :count).by(1)
      end
    end

    context 'when address creation failed' do
      let(:invalid_city) { FFaker::Internet.email }
      let(:address_params) { attributes_for(:billing_address, user_account_id: user.id, city: invalid_city) }

      it { is_expected.to render_template(:new) }

      it 'assigns variables with separate objects' do
        expect(assigns(:billing_address)).to be_a(BillingAddress)
        expect(assigns(:shipping_address)).to be_a(ShippingAddress)
        expect(assigns(:billing_address)).not_to eq(assigns(:shipping_address))
      end

      it 'not creates new address', skip_request: true do
        expect { make_request }.not_to change(Address, :count)
      end
    end

    context 'when address type not allowed' do
      let(:address_params) { attributes_for(:address, user_account_id: user.id, type: FFaker::Lorem.word) }

      it { is_expected.to rescue_from(ActiveRecord::SubclassNotFound).with(:subclass_not_found) }
      it { is_expected.to set_flash[:error].to(I18n.t('addresses.errors.type_not_allowed')) }
    end
  end

  describe '#update' do
    let(:make_request) { put :update, params: { address: address_params, id: user.billing_address.id } }

    before do |example|
      create(:billing_address, user_account_id: user.id)
      make_request unless example.metadata[:skip_request]
      user.reload
    end

    context 'when address updated' do
      let(:address_params) { attributes_for(:billing_address, user_account_id: user.id) }

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to redirect_to(action: :new) }
      it { is_expected.to set_flash[:notice].to(I18n.t('addresses.update.success')) }

      it 'update existing address of current user' do
        expect(user.billing_address).not_to be_nil
        expect(user.billing_address.address).to eq(address_params[:address])
      end

      it 'assigns address variable to user`s corresponding address' do
        expect(assigns(:billing_address)).to eq(user.billing_address)
      end

      it 'not create a new address record', skip_request: true do
        expect { make_request }.not_to change(Address, :count)
      end
    end

    context 'when address updating failed' do
      let(:invalid_city) { FFaker::Internet.email }
      let(:address_params) { attributes_for(:billing_address, user_account_id: user.id, city: invalid_city) }
      let(:errors_path) { %w[activerecord errors models address attributes] }
      let(:error_message) { Regexp.new(I18n.t('city.invalid', scope: errors_path)) }

      it { is_expected.to render_template(:new) }

      it 'not updates user`s address' do
        expect(user.billing_address.address).not_to eq(address_params[:address])
      end

      it 'assigns address variable with corresponding error' do
        expect(assigns(:address).errors.full_messages.first).to match(error_message)
      end

      it 'assigns variables with separate objects' do
        expect(assigns(:billing_address)).to be_a(BillingAddress)
        expect(assigns(:billing_address)).not_to eq(assigns(:shipping_address))
      end
    end
  end
end
