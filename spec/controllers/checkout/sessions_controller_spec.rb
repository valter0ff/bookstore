# frozen_string_literal: true

RSpec.describe Checkout::SessionsController, type: :controller do
  let(:success_status) { 200 }

  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#new' do
    context 'when user is not logged in' do
      before { get :new }

      it { is_expected.to respond_with(success_status) }

      it 'renders `new` template' do
        expect(response).to render_template(:new)
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user_account) }

      before do
        sign_in(user)
        get :new
      end

      it { is_expected.to redirect_to(new_checkout_address_path) }
    end
  end

  describe '#create' do
    before { post :create, params: { user: { email: email, password: password } } }

    context 'with correct credentials' do
      let!(:user) { create(:user_account) }
      let(:email) { user.email }
      let(:password) { user.password }
      let(:notice_message) { I18n.t('devise.sessions.signed_in') }

      it 'sings in user' do
        expect(controller.current_user).to eq(user)
      end

      it { is_expected.to redirect_to(new_checkout_address_path) }
      it { is_expected.to set_flash[:notice].to(notice_message) }
    end

    context 'with wrong credentials' do
      let(:email) { FFaker::Internet.email }
      let(:password) { FFaker::Internet.password }
      let(:error_message) { I18n.t('devise.failure.invalid', authentication_keys: 'Email') }

      it { is_expected.to render_template(:new) }

      it 'assigns flash alert with corresponding error' do
        expect(flash[:alert]).to match(error_message)
      end
    end
  end

  describe '#sign_up' do
    let(:make_request) { post :sign_up, params: { user_account: { email: email } } }
    let(:errors_path) { %w[activerecord errors models user_account attributes] }

    before do |example|
      make_request unless example.metadata[:skip_request]
    end

    context 'when email format is correct' do
      let(:email) { FFaker::Internet.email }
      let(:redirect_status) { 302 }
      let(:notice_message) { I18n.t('devise.registrations.account_created') }

      it 'creates user account in database', skip_request: true do
        expect { make_request }.to change(UserAccount, :count).by(1)
      end

      it { is_expected.to redirect_to(new_checkout_address_path) }
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
      let!(:user) { create(:user_account) }
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
