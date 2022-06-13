# frozen_string_literal: true

RSpec.shared_examples 'form have all elements' do
  it do
    expect(form).to have_first_name_label
    expect(form).to have_first_name_input
    expect(form).to have_last_name_label
    expect(form).to have_last_name_input
    expect(form).to have_address_label
    expect(form).to have_address_input
    expect(form).to have_city_label
    expect(form).to have_city_input
    expect(form).to have_zip_label
    expect(form).to have_zip_input
    expect(form).to have_country_label
    expect(form).to have_country_input
    expect(form).to have_phone_label
    expect(form).to have_phone_input
  end
end

RSpec.shared_examples 'address update success' do
  it 'user`s address fields match params fields' do
    expect(address.first_name).to eq(request_params[:first_name])
    expect(address.last_name).to eq(request_params[:last_name])
    expect(address.address).to eq(request_params[:address])
    expect(address.city).to eq(request_params[:city])
    expect(address.zip).to eq(request_params[:zip])
    expect(address.country_code).to eq(request_params[:country_code])
    expect(address.phone).to eq(request_params[:phone])
  end
end

RSpec.shared_examples 'submitted form with error' do |attribute|
  let(:errors_path) { %w[activerecord errors models address attributes] }
  let(:error_message) { I18n.t("#{attribute}.invalid", scope: errors_path) }

  it 'shows error message' do
    page.fill_form_fields(form, params)
    form.submit_button.click
    expect(form.error_message.text).to match(error_message)
  end
end
