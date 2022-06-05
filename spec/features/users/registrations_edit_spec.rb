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

  describe 'page elements present' do
    context 'when renders page' do
      it 'all page elements present' do
        expect(page).to have_page_title
        expect(page).to have_address_tab
        expect(page).to have_privacy_tab
        expect(page).to have_email_form
        expect(page).to have_password_form
        expect(page).to have_remove_account_form
        expect(page).to have_upload_image_form
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

    context 'when shows upload image form' do
      let(:upload_image_form) { page.upload_image_form }

      it 'all elements present' do
        expect(upload_image_form).to have_file_upload_input
        expect(upload_image_form).to have_submit_btn
      end
    end
  end

  describe 'email updating' do
    before { page.fill_and_submit_email_form(new_email) }

    context 'when email update successful' do
      let(:new_email) { FFaker::Internet.email }

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

      it 'does not update user email' do
        expect(user.reload.email).not_to eq(new_email)
      end

      it 'shows error message' do
        expect(page.email_form.error_message.text).to match(error_message)
      end
    end
  end

  describe 'password updating' do
    before { page.fill_and_submit_password_form(password, new_password) }

    context 'when password password successfull' do
      let(:new_password) { "#{FFaker::Internet.password}bB1" }

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
      let(:new_password) { "#{FFaker::Lorem.word}xxxxxx" }
      let(:error_message) { I18n.t('password.invalid', scope: errors_path) }

      it 'does not updates user password' do
        expect(user.reload).not_to be_valid_password(new_password)
      end

      it 'does not changes old user password' do
        expect(user.reload).not_to be_encrypted_password_changed
      end

      it 'shows error message' do
        expect(page.password_form.error_message.text).to match(error_message)
      end
    end
  end

  describe 'account destoying' do
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

  describe 'image uploading' do
    let(:upload_image_form) { page.upload_image_form }
    let(:file_path) { "spec/fixtures/images/#{file_name}" }

    before { page.upload_avatar(file_path) }

    context 'when file upload successfull' do
      let(:file_name) { 'valid_image.jpg' }

      it 'updates user avatar, shows preview and destroy checkbox' do
        expect(upload_image_form).to have_avatar_preview
        expect(upload_image_form).to have_destroy_checkbox
        expect(user.reload.picture.image.original_filename).to eq(file_name)
      end

      it 'shows apropriate flash message' do
        expect(page).to have_flash_notice
        expect(page.flash_notice.text).to eq(notice_message)
      end
    end

    context 'when upload image with wrong format' do
      let(:file_name) { 'invalid-format-image.gif' }
      let(:error_wrong_extension) do
        I18n.t('file.wrong_extension',
               list: Constants::Images::IMAGE_EXTENSIONS.join(', ').upcase)
      end
      let(:error_wrong_mime_type) do
        I18n.t('file.wrong_mime_type',
               list: Constants::Images::IMAGE_MIME_TYPES.join(', ').upcase)
      end

      it 'not updates user avatar' do
        expect(user.reload.picture).to be_nil
      end

      it 'shows error messages' do
        expect(upload_image_form.error_message.first.text).to match(error_wrong_extension)
        expect(upload_image_form.error_message.last.text).to match(error_wrong_mime_type)
      end
    end

    context 'when upload to big image' do
      let(:file_name) { 'too_big_image.jpg' }
      let(:error_big_size) do
        I18n.t('file.size_exceeded',
               size: ImageUploader::IMAGE_MAX_MB_SIZE)
      end

      it 'not updates user avatar' do
        expect(user.reload.picture).to be_nil
      end

      it 'shows error message' do
        expect(upload_image_form.error_message.first.text).to match(error_big_size)
      end
    end

    context 'when delete avatar' do
      let(:file_name) { 'valid_image.jpg' }

      it 'deletes user avatar' do
        expect(user.reload.picture.class).to be(Picture)
        page.delete_avatar
        expect(user.reload.picture).to be_nil
      end
    end
  end
end
