# frozen_string_literal: true

RSpec.describe 'Orders->Index', type: :feature do
  let(:orders_index_page) { Pages::Orders::Index.new }
  let(:user) { create(:user_account) }

  describe 'loading page elements' do
    let!(:order) { create(:order, :filled, :completed, user_account: user) }

    before do
      sign_in(user)
      orders_index_page.load
    end

    context 'when whole page' do
      it 'all elements present' do
        expect(orders_index_page).to have_page_title(text: I18n.t('orders.index.my_orders'))
        expect(orders_index_page).to have_filter_title(text: I18n.t('orders.index.filter_by'))
        expect(orders_index_page).to have_filter_dropdown
      end
    end

    context 'when orders table' do
      let(:table_headers) { orders_index_page.orders_table.table_headers }
      let(:order_item_block) { orders_index_page.orders_table.order_items.first }
      let(:decorated_order) { order.decorate }

      it 'all headers present' do
        expect(table_headers).to have_number_title(text: I18n.t('orders.orders_table.number'))
        expect(table_headers).to have_completed_title(text: I18n.t('orders.orders_table.completed_at'))
        expect(table_headers).to have_status_title(text: I18n.t('orders.orders_table.status'))
        expect(table_headers).to have_total_title(text: I18n.t('orders.orders_table.total'))
      end

      it 'all elements present with correct values' do
        expect(order_item_block).to have_link_to_order(text: order.number)
        expect(order_item_block).to have_completed_at(text: decorated_order.completed_at.strftime('%F'))
        expect(order_item_block).to have_status(text: decorated_order.state.sub('_', ' ').capitalize)
        expect(order_item_block).to have_price(text: decorated_order.total_with_shipping)
      end
    end
  end

  describe 'using orders state filter' do
    let!(:order_in_progress) { create(:order, :completed, user_account: user) }
    let!(:order_in_delivery) { create(:order, :completed, user_account: user, state: :in_delivery) }
    let!(:order_delivered) { create(:order, :completed, user_account: user, state: :delivered) }
    let!(:order_canceled) { create(:order, :completed, user_account: user, state: :canceled) }
    let(:order_items) { orders_index_page.orders_table.order_items }
    let(:option) { orders_index_page.filter_dropdown.find(:option, text: text) }

    before do
      sign_in(user)
      orders_index_page.load
    end

    context 'when filter not used' do
      it 'shows all user`s completed orders' do
        expect(order_items.count).to eq(user.orders.complete.count)
      end
    end

    context 'when select `In progress` option', js: true do
      let(:text) { I18n.t('orders.state_filter.in_progress') }

      before { option.select_option }

      it 'shows only user`s orders with `in_progress` state' do
        expect(order_items.first.link_to_order.text).to eq(order_in_progress.number)
        expect(order_items.count).to eq(1)
      end
    end

    context 'when select `In delivery` option', js: true do
      let(:text) { I18n.t('orders.state_filter.in_delivery') }

      before { option.select_option }

      it 'shows only user`s orders with `in_delivery` state' do
        expect(order_items.first.link_to_order.text).to eq(order_in_delivery.number)
        expect(order_items.count).to eq(1)
      end
    end

    context 'when select `Delivered` option', js: true do
      let(:text) { I18n.t('orders.state_filter.delivered') }

      before { option.select_option }

      it 'shows only user`s orders with `delivered` state' do
        expect(order_items.first.link_to_order.text).to eq(order_delivered.number)
        expect(order_items.count).to eq(1)
      end
    end

    context 'when select `Canceled` option', js: true do
      let(:text) { I18n.t('orders.state_filter.canceled') }

      before { option.select_option }

      it 'shows only user`s orders with `canceled` state' do
        expect(order_items.first.link_to_order.text).to eq(order_canceled.number)
        expect(order_items.count).to eq(1)
      end
    end
  end
end
