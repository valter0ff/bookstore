# frozen_string_literal: true

RSpec.shared_examples 'validatable atrribute' do |attribute|
  let(:errors_path) { %w[activerecord errors models address attributes] }
  let(:blank_error) { I18n.t('activerecord.errors.messages.blank') }
  let(:invalid_error) { I18n.t("#{attribute}.invalid", scope: errors_path) }
  let(:address_params) { attributes_for(:address) }

  it { is_expected.to validate_presence_of(attribute).with_message(blank_error) }
  it { is_expected.to validate_length_of(attribute).is_at_most(attr_max_size) }
  it { is_expected.to allow_value(address_params[attribute]).for(attribute) }
  it { is_expected.not_to allow_value(attr_restricted_value).for(attribute).with_message(invalid_error) }
end
