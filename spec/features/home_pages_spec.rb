# frozen_string_literal: true

RSpec.describe 'HomePages' do
  let(:home_page) { Pages::HomePages::Index.new }

  before { home_page.load }

  it 'displays the root page' do
    expect(home_page).to be_all_there
  end
end
