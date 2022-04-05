# frozen_string_literal: true

RSpec.describe AddressesController, type: :controller do
  let(:success_status) { 200 }
  
  describe '#new' do
    before { get :new }
    
    context 'with success response' do
      it 'has a 200 status code' do
        expect(response.status).to eq(success_status)
      end

      it 'renders index template' do
        expect(response).to render_template(:new)
      end
      
      it 'assigns address resource to be expected subclass of Address' do
        expect(assigns(:billing_address)).to be_an_instance_of(BillingAddress)
        expect(assigns(:shipping_address)).to be_an_instance_of(ShippingAddress)
        expect(assigns(:billing_address)).to be_kind_of(Address)
        expect(assigns(:billing_address)).to be_kind_of(Address)
      end
    end
  end
end
