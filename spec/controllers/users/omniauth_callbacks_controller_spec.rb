# frozen_string_literal: true

RSpec.describe Users::OmniauthCallbacksController do
  let(:user) { create(:user_account) }
  let(:auth_hash) { { provider: :facebook, uid: rand(5..10), info: info } }
  let(:info) { { email: FFaker::Internet.email } }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(auth_hash)
  end

  describe '#facebook' do
    context 'when login successful' do
      before do
        allow(UserAccount).to receive(:from_omniauth).and_return(user)
        get :facebook
      end

      it 'authenticate user' do
        expect(warden).to be_authenticated(:user)
      end

      it 'set current_user' do
        expect(controller.current_user).not_to be_nil
      end

      it 'redirect to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
