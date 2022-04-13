# frozen_string_literal: true

RSpec.describe 'Addresses' do
  describe '#new' do
    let(:page) { Pages::Addresses::New.new }
    let(:user) { create(:user_account) }

    before do
      sign_in(user)
      page.load
    end

    context 'when all page elements present' do
      it { expect(page).to have_page_title }
      it { expect(page).to have_address_tab }
      it { expect(page).to have_privacy_tab }
      it { expect(page).to have_billing_title }
      it { expect(page).to have_shipping_title }
      it { expect(page).to have_billing_form }
      it { expect(page).to have_shipping_form }
    end

    context 'when all elements in billing form present' do
      let(:form) { page.billing_form }

      it_behaves_like 'form have all elements'
    end

    context 'when all elements in shipping form present' do
      let(:form) { page.shipping_form }

      it_behaves_like 'form have all elements'
    end

    context 'when submit billing form with valid data' do
      let(:params) { attributes_for(:billing_address) }
      let(:address) { user.reload.billing_address }
      let(:form) { page.billing_form }

      it_behaves_like 'submitted form with success result'
    end

    context 'when submit shipping form with valid data' do
      let(:params) { attributes_for(:shipping_address) }
      let(:address) { user.reload.shipping_address }
      let(:form) { page.shipping_form }

      it_behaves_like 'submitted form with success result'
    end

    context 'when submit billing form with invalid data' do
      let(:params) { attributes_for(:billing_address, city: FFaker::Internet.email) }
      let(:form) { page.billing_form }

      it_behaves_like 'submitted form with error', :city
    end

    context 'when submit shipping form with invalid data' do
      let(:params) { attributes_for(:shipping_address, city: FFaker::Internet.email) }
      let(:form) { page.shipping_form }

      it_behaves_like 'submitted form with error', :city
    end
  end
end
