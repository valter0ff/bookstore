# frozen_string_literal: true

RSpec.describe Checkout::PaymentsController, type: :controller do
  describe '#edit' do
    context 'when user is not logged in' do
      it_behaves_like 'a redirect to checkout login page'
    end

    context 'when user is logged in' do
      it_behaves_like 'a success render current page'
    end
  end

  describe '#update' do
    let(:user) { create(:user_account) }
    let(:make_request) { put :update, params: params }
    let(:order) { controller.current_user.reload_current_order }
    let(:params) { { order: { credit_card_attributes: card_attrs } } }

    before do |example|
      sign_in(user)
      make_request unless example.metadata[:skip_request]
    end

    context 'when order update success' do
      let(:card_attrs) { attributes_for(:credit_card) }
      let(:success_message) { I18n.t('checkout.payments.edit.credit_card_saved') }

      it { is_expected.to redirect_to(new_checkout_confirm_path) }
      it { is_expected.to set_flash[:notice].to(success_message) }

      it 'updates credit card for order of current user' do
        expect(order.credit_card.id).to eq(CreditCard.first.id)
      end

      it 'creates new credit card in database', skip_request: true do
        expect { make_request }.to change(CreditCard, :count).from(0).to(1)
      end
    end

    context 'when order update not success' do
      let(:card_attrs) do
        { number: FFaker::Lorem.word,
          holder_name: FFaker::Internet.email,
          expiry_date: '',
          cvv_code: '' }
      end
      let(:errors_path) { %w[activerecord errors models credit_card attributes] }
      let(:format_error_message) { I18n.t('number.invalid', scope: errors_path) }
      let(:invalid_error_message) { I18n.t('errors.messages.invalid') }
      let(:blank_error_message) { I18n.t('activerecord.errors.messages.blank') }

      it { is_expected.to render_template(:edit) }

      it 'doesn`t update order`s credit card' do
        expect(order.credit_card).to be_nil
      end

      it 'doesn`t create new credit card in database', skip_request: true do
        expect { make_request }.not_to change(CreditCard, :count)
      end

      it 'assigns current order card attributes with corresponding errors' do
        expect(assigns(:order).errors['credit_card.number'].first).to match(format_error_message)
        expect(assigns(:order).errors['credit_card.holder_name'].first).to match(invalid_error_message)
        expect(assigns(:order).errors['credit_card.expiry_date'].first).to match(blank_error_message)
        expect(assigns(:order).errors['credit_card.cvv_code'].first).to match(blank_error_message)
      end
    end
  end
end
