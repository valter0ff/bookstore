# frozen_string_literal: true

RSpec.describe 'Users::Registrations', type: :feature do
  let(:page) { Pages::Devise::Registrations::Edit.new }
  let(:password) { "#{FFaker::Internet.password}aA1" }
  let(:user) { create(:user_account, password: password) }
  let(:errors_path) { %w[activerecord errors models user_account attributes] }
  let(:notice_message) { I18n.t('devise.registrations.updated') }

  before do
    sign_in(user)
    page.load
  end

  context 'when renders page' do
    it 'all page elements present' do
      expect(page).to have_page_title
      expect(page).to have_address_tab
      expect(page).to have_privacy_tab
      expect(page).to have_email_form
      expect(page).to have_password_form
      expect(page).to have_remove_account_form
    end
  end

  context 'when shows email form' do
    let(:email_form) { page.email_form }

    it 'all elements present' do
      expect(email_form).to have_email_label
      expect(email_form).to have_email_input
      expect(email_form).to have_submit_btn
    end
  end

  context 'when shows password form' do
    let(:password_form) { page.password_form }

    it 'all elements present' do
      expect(password_form).to have_current_password_label
      expect(password_form).to have_current_password_input
      expect(password_form).to have_new_password_label
      expect(password_form).to have_new_password_input
      expect(password_form).to have_password_confirmation_label
      expect(password_form).to have_password_confirmation_input
      expect(password_form).to have_submit_btn
    end
  end

  context 'when shows remove account form' do
    let(:remove_account_form) { page.remove_account_form }

    it 'all elements present' do
      expect(remove_account_form).to have_form_title
      expect(remove_account_form).to have_remove_account_button
      expect(remove_account_form).to have_confirmation_checkbox
    end
  end

  context 'when email update successful' do
    let(:new_email) { FFaker::Internet.email }

    before { page.fill_and_submit_email_form(new_email) }

    it 'updates user email' do
      expect(user.reload.email).to eq(new_email)
    end

    it 'shows apropriate flash message' do
      expect(page).to have_flash_notice
      expect(page.flash_notice.text).to eq(notice_message)
    end
  end

  context 'when email update failed' do
    let(:new_email) { FFaker::Lorem.word }
    let(:error_message) { I18n.t('email.invalid', scope: errors_path) }

    before { page.fill_and_submit_email_form(new_email) }

    it 'does not update user email' do
      expect(user.reload.email).not_to eq(new_email)
    end

    it 'shows error message' do
      expect(page.email_form.error_message.text).to match(error_message)
    end
  end

  context 'when password password successfull' do
    let(:new_password) { "#{FFaker::Internet.password}bB1" }

    before { page.fill_and_submit_password_form(password, new_password) }

    it 'updates user password' do
      expect(user.reload).to be_valid_password(new_password)
    end

    it 'changes old user password' do
      expect(user.reload).not_to be_valid_password(password)
    end

    it 'shows apropriate flash message' do
      expect(page).to have_flash_notice
      expect(page.flash_notice.text).to eq(notice_message)
    end
  end

  context 'when password update failed' do
    let(:new_password) { FFaker::Lorem.word * rand(5..7) }
    let(:error_message) { I18n.t('password.invalid', scope: errors_path) }

    before { page.fill_and_submit_password_form(password, new_password) }

    it 'does not updates user password' do
      expect(user.reload).not_to be_valid_password(new_password)
    end

    it 'does not changes old user password' do
      expect(user.reload).to be_valid_password(password)
    end

    it 'shows error message' do
      expect(page.password_form.error_message.text).to match(error_message)
    end
  end

  context 'when user deleted' do
    let(:notice_message) { I18n.t('devise.registrations.destroyed') }
    let(:remove_user_form) { page.remove_account_form }

    it 'does deletes user' do
      expect { page.remove_account }.to change(UserAccount, :count).by(-1)
    end

    it 'shows apropriate flash message' do
      page.remove_account
      expect(page).to have_flash_notice
      expect(page.flash_notice.text).to eq(notice_message)
    end
  end
end
