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
        expect(credit_card_form).to have_holdre_name_label(text: I18n.t('checkout.payments.edit.name_on_card'))
        expect(credit_card_form).to have_holdre_name_input
        expect(credit_card_form).to have_expiry_date_label(text: I18n.t('checkout.payments.edit.expiry_date'))
        expect(credit_card_form).to have_expiry_date_input
        expect(credit_card_form).to have_cvv_code_label(text: I18n.t('checkout.payments.edit.cvv_code'))
        expect(credit_card_form).to have_cvv_code_input
        expect(credit_card_form).to have_submit_button
      end
    end
  end
end
