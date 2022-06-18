# frozen_string_literal: true

RSpec.shared_examples 'checkout progressbar have all elements' do
  it 'all elements present' do
    expect(progress_bar).to have_step_number_one
    expect(progress_bar).to have_step_number_two
    expect(progress_bar).to have_step_number_three
    expect(progress_bar).to have_step_number_four
    expect(progress_bar).to have_step_number_five
    expect(progress_bar).to have_address_label
    expect(progress_bar).to have_delivery_label
    expect(progress_bar).to have_payment_label
    expect(progress_bar).to have_confirm_label
    expect(progress_bar).to have_complete_label
  end
end
