# frozen_string_literal: true

RSpec.describe 'Checkout::Payments->Edit', type: :feature do
  let(:payments_edit_page) { Pages::Checkout::Payments::Edit.new }
  let(:user) { create(:user_account) }

  before do
    sign_in(user)
    payments_edit_page.load
  end

  describe 'loading page elements' do
    context 'when whole page' do
      it 'all elements present' do
        expect(payments_edit_page).to have_page_title(text: I18n.t('checkout.shared.general_title'))
        expect(payments_edit_page).to have_payment_subtitle(text: I18n.t('checkout.payments.edit.credit_card'))
        expect(payments_edit_page).to have_credit_card_form
        expect(payments_edit_page).to have_checkout_progress_bar
        expect(payments_edit_page).to have_order_summary_title
        expect(payments_edit_page).to have_order_summary_table
      end
    end

    context 'when checkout progress bar' do
      let(:progress_bar) { payments_edit_page.checkout_progress_bar }

      it_behaves_like 'checkout progressbar have all elements'
    end

    context 'when order summary table' do
      let(:order_summary) { payments_edit_page.order_summary_table }

      it_behaves_like 'order summary block have all elements'
    end

    context 'when credit card form' do
      let(:credit_card_form) { payments_edit_page.credit_card_form }

      it 'all elements present' do
        expect(credit_card_form).to have_card_number_label(text: I18n.t('checkout.payments.edit.card_number'))
        expect(credit_card_form).to have_card_number_input
        expect(credit_card_form).to have_holder_name_label(text: I18n.t('checkout.payments.edit.name_on_card'))
        expect(credit_card_form).to have_holder_name_input
        expect(credit_card_form).to have_expiry_date_label(text: I18n.t('checkout.payments.edit.expiry_date'))
        expect(credit_card_form).to have_expiry_date_input
        expect(credit_card_form).to have_cvv_code_label(text: I18n.t('checkout.payments.edit.cvv_code'))
        expect(credit_card_form).to have_cvv_code_input
        expect(credit_card_form).to have_submit_button
      end
    end
  end

  describe 'submitting form' do
    let(:credit_card_form) { payments_edit_page.credit_card_form }

    before { credit_card_form.fill_and_submit(params) }

    context 'with all fields correct data' do
      let(:success_message) { I18n.t('checkout.payments.edit.credit_card_saved') }
      let(:params) { attributes_for(:credit_card) }
      let(:card) { user.reload.current_order.credit_card }

      it 'updates order`s credit card infortmation' do
        expect(card.number).to eq(params[:number])
        expect(card.holder_name).to eq(params[:holder_name])
        expect(card.expiry_date).to eq(params[:expiry_date])
        expect(card.cvv_code).to eq(params[:cvv_code])
      end

      it 'redirects to checkout confirm page' do
        expect(payments_edit_page).to have_current_path(new_checkout_confirm_path)
      end

      it 'shows success flash message' do
        expect(payments_edit_page).to have_flash_notice(text: success_message)
      end
    end

    context 'with all fields incorrect data' do
      context 'when all blank' do
        let(:blank_error_message) { I18n.t('activerecord.errors.messages.blank') }
        let(:params) { { number: '', holder_name: '', expiry_date: '', cvv_code: '' } }

        it 'shows errors messages in form' do
          expect(credit_card_form).to have_card_number_error(text: blank_error_message)
          expect(credit_card_form).to have_holder_name_error(text: blank_error_message)
          expect(credit_card_form).to have_expiry_date_error(text: blank_error_message)
          expect(credit_card_form).to have_cvv_code_error(text: blank_error_message)
        end
      end

      context 'with invalid data format' do
        let(:errors_path) { %w[activerecord errors models credit_card attributes] }
        let(:number_invalid_error_message) { I18n.t('number.invalid', scope: errors_path) }
        let(:shared_invalid_error_message) { I18n.t('errors.messages.invalid') }
        let(:params) do
          { number: FFaker::Lorem.word,
            holder_name: FFaker::Internet.email,
            expiry_date: FFaker::Lorem.word,
            cvv_code: FFaker::Lorem.word }
        end

        it 'shows errors messages in form' do
          expect(credit_card_form).to have_card_number_error(text: number_invalid_error_message)
          expect(credit_card_form).to have_holder_name_error(text: shared_invalid_error_message)
          expect(credit_card_form).to have_expiry_date_error(text: shared_invalid_error_message)
          expect(credit_card_form).to have_cvv_code_error(text: shared_invalid_error_message)
        end
      end

      context 'when fields data too long' do
        let(:invalid_error_message) { I18n.t('errors.messages.invalid') }
        let(:too_long_card_number_error) do
          I18n.t('errors.messages.too_long',
                 count: Constants::CreditCard::NUMBER_MAX_SIZE)
        end
        let(:too_long_holder_name_error) do
          I18n.t('errors.messages.too_long',
                 count: Constants::CreditCard::HOLDER_NAME_MAX_SIZE)
        end
        let(:shared_invalid_error_message) { I18n.t('errors.messages.invalid') }
        let(:params) do
          { number: FFaker::Bank.card_number.delete(' ') * rand(2..3),
            holder_name: FFaker::Lorem.word * rand(30..40),
            expiry_date: FFaker::Bank.card_expiry_date * rand(2..3),
            cvv_code: rand(100..9999).to_s * rand(2..3) }
        end

        it 'shows errors messages in form' do
          expect(credit_card_form).to have_card_number_error(text: too_long_card_number_error)
          expect(credit_card_form).to have_holder_name_error(text: too_long_holder_name_error)
          expect(credit_card_form).to have_expiry_date_error(text: shared_invalid_error_message)
          expect(credit_card_form).to have_cvv_code_error(text: shared_invalid_error_message)
        end
      end
    end
  end
end
