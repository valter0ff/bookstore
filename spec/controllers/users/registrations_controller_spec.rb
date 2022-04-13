# frozen_string_literal: true

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:success_status) { 200 }
  let(:redirect_status) { 302 }
  let(:user) { controller.current_user }
  let(:password) { "#{FFaker::Internet.password}aA1" }
  let(:make_request) { put :update, params: { user: params } }

  before do |example|
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(create(:user_account, password: password))
    get :edit
    make_request unless example.metadata[:skip_request]
  end

  context 'with success response', skip_request: true do
    it { is_expected.to respond_with(success_status) }
    it { is_expected.to render_template(:edit) }
  end

  describe 'update email' do
    context 'when email update successfull' do
      let(:params) { { email: FFaker::Internet.email } }

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
      let(:new_password) { "#{FFaker::Internet.password}aA1" }
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
      let(:new_password) { FFaker::Lorem.word }

      shared_examples 'update not successful' do |attribute|
        it 'not updates user password' do
          expect(user.reload.valid_password?(new_password)).to be false
        end

        it 'shows error message' do
          expect(assigns(:user).errors.messages[attribute].first).to match(error_message)
        end
      end

      context 'with new password invalid format' do
        let(:new_password) { FFaker::Lorem.word * rand(3..5) }
        let(:error_message) { I18n.t('password.invalid', scope: errors_path) }

        it_behaves_like 'update not successful', :password
      end

      context 'with blank new password' do
        let(:new_password) { '' }
        let(:error_message) { 'is too short (minimum is 8 characters)' }

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
end
