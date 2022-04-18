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
    expect(form).to have_submit_button
  end
end

RSpec.shared_examples 'submitted form with success result' do
  let(:address_type) { params[:type] }

  before do |example|
    page.fill_and_submit_form(form, params) unless example.metadata[:skip_before]
  end

  it 'creates new address record', skip_before: true do
    expect { page.fill_and_submit_form(form, params) }.to change(Address, :count).by(1)
  end

  it 'creates an address of apropriate type' do
    expect(address.type).to eq(address_type)
  end

  it 'creates address for current user' do
    expect(address.first_name).to eq(params[:first_name])
    expect(address.last_name).to eq(params[:last_name])
    expect(address.address).to eq(params[:address])
    expect(address.city).to eq(params[:city])
    expect(address.zip).to eq(params[:zip])
    expect(address.country_code).to eq(params[:country_code])
    expect(address.phone).to eq(params[:phone])
  end
end

RSpec.shared_examples 'submitted form with error' do |attribute|
  let(:errors_path) { %w[activerecord errors models address attributes] }
  let(:error_message) { I18n.t("#{attribute}.invalid", scope: errors_path) }

  it 'does not creates new address', skip_before: true do
    expect { page.fill_and_submit_form(form, params) }.not_to change(Address, :count)
  end

  it 'shows error message' do
    page.fill_and_submit_form(form, params)
    expect(form.error_message.text).to match(error_message)
  end
end
