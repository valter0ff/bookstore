# frozen_string_literal: true

RSpec.shared_examples 'a redirect to checkout login page' do
  before { get :edit }

  it { is_expected.to redirect_to(new_checkout_session_path) }
end

RSpec.shared_examples 'a success render current page' do
  let(:success_status) { 200 }
  let(:user) { create(:user_account) }

  before do
    sign_in(user)
    get :edit
  end

  it { is_expected.to respond_with(success_status) }
  it { is_expected.to render_template(:edit) }
end
