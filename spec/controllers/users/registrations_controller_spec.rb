# frozen_string_literal: true

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:user) { controller.current_user }
  let(:user_account) { create(:user_account, password: password) }
  let(:password) { "#{FFaker::Internet.password}aA1" }
  let(:make_request) { put :update, params: { user: params } }

  before do |example|
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user_account)
    make_request unless example.metadata[:skip_request]
  end

  context 'with success response', skip_request: true do
    let(:success_status) { 200 }

    before { get :edit }

    it { is_expected.to respond_with(success_status) }
    it { is_expected.to render_template(:edit) }
  end

  describe 'update email' do
    context 'when email update successfull' do
      let(:params) { { email: FFaker::Internet.email } }
      let(:redirect_status) { 302 }

      it 'updates user email' do
        expect(user.reload.email).to eq(params[:email])
      end

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to set_flash[:notice].to(I18n.t('devise.registrations.updated')) }
    end

    context 'when email update failed' do
      let(:params) { { email: FFaker::Lorem.word } }
      let(:errors_path) { %w[activerecord errors models user_account attributes] }
      let(:error_message) { Regexp.new(I18n.t('email.invalid', scope: errors_path)) }

      it 'not updates user email' do
        expect(user.reload.email).not_to eq(params[:email])
      end

      it 'shows error message' do
        expect(assigns(:user).errors.messages[:email].first).to match(error_message)
      end
    end
  end

  describe 'update password' do
    context 'when password update successfull' do
      let(:redirect_status) { 302 }
      let(:new_password) { "#{FFaker::Internet.password}bB1" }
      let(:params) { { current_password: password, password: new_password, password_confirmation: new_password } }

      it 'updates user password' do
        expect(user.reload.valid_password?(new_password)).to be true
      end

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to set_flash[:notice].to(I18n.t('devise.registrations.updated')) }
    end

    context 'when password update failed' do
      let(:params) { { current_password: password, password: new_password, password_confirmation: new_password } }
      let(:errors_path) { %w[activerecord errors models user_account attributes] }
      let(:new_password) { "#{FFaker::Lorem.word}xxxxxx" }

      shared_examples 'update not successful' do |attribute|
        it 'not updates user password' do
          expect(user.reload.valid_password?(new_password)).to be false
        end

        it 'shows error message' do
          expect(assigns(:user).errors.messages[attribute].first).to match(error_message)
        end
      end

      context 'with new password invalid format' do
        let(:new_password) { FFaker::Internet.email }
        let(:error_message) { I18n.t('password.invalid', scope: errors_path) }

        it_behaves_like 'update not successful', :password
      end

      context 'with blank new password' do
        let(:params) { { current_password: password, password: '', password_confirmation: new_password } }
        let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

        it_behaves_like 'update not successful', :password
      end

      context 'with invalid old password' do
        let(:params) { { current_password: new_password, password: new_password, password_confirmation: new_password } }
        let(:error_message) { I18n.t('errors.messages.invalid') }

        it_behaves_like 'update not successful', :current_password
      end

      context 'with invalid new password confirmation' do
        let(:params) { { current_password: password, password: new_password, password_confirmation: '' } }
        let(:error_message) { I18n.t('password_confirmation.confirmation', scope: errors_path) }

        it_behaves_like 'update not successful', :password_confirmation
      end
    end
  end

  describe 'delete account', skip_request: true do
    context 'when success' do
      it 'redirects to root path' do
        delete :destroy
        expect(controller).to redirect_to(root_path)
      end

      it 'deletes user account' do
        expect { delete :destroy }.to change(UserAccount, :count).by(-1)
      end

      it 'sets flash message' do
        delete :destroy
        expect(controller).to set_flash[:notice].to(I18n.t('devise.registrations.destroyed'))
      end
    end
  end

  describe 'update picture' do
    let(:params) { { picture_attributes: { image: Rack::Test::UploadedFile.new(*file_params) } } }
    let(:file_params) { ["spec/fixtures/images/#{file_name}", mime_type] }

    context 'when upload image successfull' do
      let(:file_name) { 'valid_image.jpg' }
      let(:mime_type) { 'image/jpeg' }
      let(:redirect_status) { 302 }
      let(:user_picture) { user.reload.picture.image }

      it 'updates user avatar', skip_request: true do
        expect { make_request }.to change { user.reload.picture.class }.from(NilClass).to(Picture)
      end

      it 'updates `Picture` model count', skip_request: true do
        expect { make_request }.to change(Picture, :count).by(1)
      end

      it 'updates user avatar image file' do
        expect(user_picture.original_filename).to eq(file_name)
        expect(user_picture.mime_type).to eq(mime_type)
      end

      it { is_expected.to redirect_to(edit_user_registration_path) }
      it { is_expected.to set_flash[:notice].to(I18n.t('devise.registrations.updated')) }
    end

    context 'when upload gif image' do
      let(:file_name) { 'invalid-format-image.gif' }
      let(:mime_type) { 'image/gif' }
      let(:error_message_ext) do
        I18n.t('file.wrong_extension',
               list: Constants::Images::IMAGE_EXTENSIONS.join(', ').upcase)
      end
      let(:error_message_mime) do
        I18n.t('file.wrong_mime_type',
               list: Constants::Images::IMAGE_MIME_TYPES.join(', ').upcase)
      end

      it 'does not create new picture', skip_request: true do
        expect { make_request }.not_to change(Picture, :count)
      end

      it 'returns image validation errors' do
        expect(assigns(:user).errors[:'picture.image'].first).to match(error_message_ext)
        expect(assigns(:user).errors[:'picture.image'].last).to match(error_message_mime)
      end
    end

    context 'when upload too big image' do
      let(:file_name) { 'too_big_image.jpg' }
      let(:mime_type) { 'image/jpeg' }
      let(:error_message_size) do
        I18n.t('file.size_exceeded',
               size: ImageUploader::IMAGE_MAX_MB_SIZE)
      end

      it 'does not create new picture', skip_request: true do
        expect { make_request }.not_to change(Picture, :count)
      end

      it 'returns image validation error' do
        expect(assigns(:user).errors[:'picture.image'].first).to match(error_message_size)
      end
    end
  end

  describe '#fast_sign_up' do
    let(:make_request) { post :fast_sign_up, params: { user: { email: email } } }
    let(:errors_path) { %w[activerecord errors models user_account attributes] }

    context 'when email format is correct' do
      let(:email) { FFaker::Internet.email }
      let(:redirect_status) { 302 }
      let(:notice_message) { I18n.t('devise.registrations.account_created') }

      it 'creates user account in database', skip_request: true do
        expect { make_request }.to change(UserAccount, :count).by(1)
      end

      it { is_expected.to redirect_to(checkout_address_path) }
      it { is_expected.to set_flash[:notice].to(notice_message) }

      it 'creates user account with provided email' do
        expect(UserAccount.last.email).to eq(email)
      end
    end

    context 'when email format is incorrect' do
      let(:error_message) { I18n.t('email.invalid', scope: errors_path) }
      let(:email) { FFaker::Lorem.word }

      it 'doesn`t create new user account', skip_request: true do
        expect { make_request }.not_to change(UserAccount, :count)
      end

      it 'shows error message' do
        expect(assigns(:user).errors.messages[:email].first).to match(error_message)
      end
    end

    context 'when account with provided email already exists' do
      let(:error_message) { I18n.t('email.taken', scope: errors_path) }
      let(:email) { user.email }

      it 'doesn`t create new user account', skip_request: true do
        expect { make_request }.not_to change(UserAccount, :count)
      end

      it 'shows error message' do
        expect(assigns(:user).errors.messages[:email].first).to match(error_message)
      end
    end
  end
end
