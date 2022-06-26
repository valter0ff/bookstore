# frozen_string_literal: true

RSpec.shared_examples 'a redirect to checkout login page' do
  before { get :edit }

  it { is_expected.to redirect_to(new_checkout_session_path) }
end

RSpec.shared_examples 'a success render current page' do
  let(:success_status) { 200 }
  let(:user) { create(:user_account) }
  let(:order) { create(:order, user_account: user) }

  before do
    sign_in(user)
    get :edit
  end

  it { is_expected.to respond_with(success_status) }
  it { is_expected.to render_template(:edit) }
end

RSpec.shared_examples 'a redirect to root with `not authorized` alert' do
  let(:user) { create(:user_account) }
  let(:order) { create(:order, user_account: user) }
  let(:not_authorized_message) { I18n.t('checkout.errors.not_authorized') }

  before do
    sign_in(user)
    get :edit
  end

  it { is_expected.to redirect_to(root_path) }
  it { is_expected.to set_flash[:alert].to(not_authorized_message) }
end
