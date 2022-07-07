# frozen_string_literal: true

RSpec.shared_examples 'a redirect to checkout login page' do
  it { is_expected.to redirect_to(new_checkout_session_path) }
end

RSpec.shared_examples 'a success render current page' do |template|
  let(:success_status) { 200 }

  it { is_expected.to respond_with(success_status) }
  it { is_expected.to render_template(template) }
end

RSpec.shared_examples 'a redirect to root with `not authorized` alert' do
  let(:not_authorized_message) { I18n.t('checkout.errors.not_authorized') }

  it { is_expected.to redirect_to(root_path) }
  it { is_expected.to set_flash[:alert].to(not_authorized_message) }
end
