# frozen_string_literal: true

RSpec.describe Orders::FilterOrdersService do
  let(:orders) { described_class.call(user, filter_option) }
  let(:user) { create(:user_account) }
  let!(:order_in_progress) { create(:order, :completed, user_account: user) }
  let!(:order_in_delivery) { create(:order, :completed, user_account: user, state: :in_delivery) }
  let!(:order_delivered) { create(:order, :completed, user_account: user, state: :delivered) }
  let!(:order_canceled) { create(:order, :completed, user_account: user, state: :canceled) }

  context 'when filter option not set' do
    let(:filter_option) { nil }

    it 'returns all user`s order with `complete` step' do
      expect(orders).to eq(user.orders.complete)
      expect(orders.count).to eq(user.orders.complete.count)
    end
  end

  context 'when filter option `in_progress`' do
    let(:filter_option) { 'in_progress' }

    it 'returns all user`s order with `complete` step and `in_progress` state' do
      expect(orders).to eq(user.orders.complete.in_progress)
      expect(orders.first).to eq(order_in_progress)
      expect(orders.count).to eq(1)
    end
  end

  context 'when filter option `in_delivery`' do
    let(:filter_option) { 'in_delivery' }

    it 'returns all user`s order with `complete` step and `in_delivery` state' do
      expect(orders).to eq(user.orders.complete.in_delivery)
      expect(orders.first).to eq(order_in_delivery)
      expect(orders.count).to eq(1)
    end
  end

  context 'when filter option `delivered`' do
    let(:filter_option) { 'delivered' }

    it 'returns all user`s order with `complete` step and `delivered` state' do
      expect(orders).to eq(user.orders.complete.delivered)
      expect(orders.first).to eq(order_delivered)
      expect(orders.count).to eq(1)
    end
  end

  context 'when filter option `canceled`' do
    let(:filter_option) { 'canceled' }

    it 'returns all user`s order with `complete` step and `canceled` state' do
      expect(orders).to eq(user.orders.complete.canceled)
      expect(orders.first).to eq(order_canceled)
      expect(orders.count).to eq(1)
    end
  end
end
