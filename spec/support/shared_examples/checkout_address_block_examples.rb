# frozen_string_literal: true

RSpec.shared_examples 'address block have all elements' do
  it 'have all elements with correct text' do
    expect(address_block).to have_address_full_name(text: "#{address.first_name} #{address.last_name}")
    expect(address_block).to have_address_address(text: address.address)
    expect(address_block).to have_address_city_zip(text: "#{address.city} #{address.zip}")
    expect(address_block).to have_address_country(text: address.country_name)
    expect(address_block).to have_address_phone(text: "#{I18n.t('checkout.address.phone')} #{address.phone}")
  end
end
