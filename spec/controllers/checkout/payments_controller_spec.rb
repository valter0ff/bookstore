# frozen_string_literal: true

RSpec.describe Checkout::DeliveriesController, type: :controller do
  describe '#edit' do
    context 'when user is not logged in' do
      it_behaves_like 'a redirect to checkout login page'
    end

    context 'when user is logged in' do
      it_behaves_like 'a success render current page'
    end
  end
end
