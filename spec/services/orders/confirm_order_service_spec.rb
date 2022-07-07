# frozen_string_literal: true

RSpec.describe Orders::ConfirmOrderService do
  let(:service_instance) { described_class.new(user, order) }
  let(:current_user) { service_instance.instance_variable_get(:@current_user) }
  let(:current_order) { service_instance.instance_variable_get(:@order) }
  let!(:address) { create(:billing_address, user_account: user) }

  before { |example| service_instance.call unless example.metadata[:skip_before] }

  describe '#call' do
    let(:user) { create(:user_account, use_billing_address: true) }
    let!(:order) { create(:order, :confirm, :filled, user_account: user) }

    context 'when save book prices and sales count' do
      let(:cart_item) { current_order.reload.cart_items.first }

      it 'saves book prices to cart_item record' do
        expect(cart_item.book_price).to eq(cart_item.book.price)
      end

      it 'update cart item book`s sales_count with books_count quantity' do
        expect(cart_item.book.sales_count).to eq(cart_item.books_count)
      end
    end

    context 'when use coupon', skip_before: true do
      let(:coupon) { current_order.reload.coupon }

      it 'changes coupon status to `used`' do
        expect { service_instance.call }.to change(coupon, :status).from('active').to('used')
      end
    end

    context 'when update order information' do
      let!(:stubbed_time) { DateTime.now.in_time_zone }
      let(:order_number) { Constants::Order::NUMBER_PREFIX + format("%0#{Constants::Order::NUMBER_SIZE}d", order.id) }

      before { allow(DateTime).to receive(:now).and_return(stubbed_time) }

      it 'update some order fields in database' do
        expect(current_order.billing_address).to eq(current_user.billing_address.to_json)
        expect(current_order.shipping_price).to eq(current_order.shipping_method.price)
        expect(current_order.completed_at.strftime('%D %R')).to eq(stubbed_time.strftime('%D %R'))
        expect(current_order.number).to eq(order_number)
      end

      it 'changes state of order to `in_progress`', skip_before: true do
        expect { service_instance.call }.to change(current_order, :state).from('in_cart').to('in_progress')
      end

      it 'changes step of order to `complete`', skip_before: true do
        expect { service_instance.call }.to change(current_order, :step).from('confirm').to('complete')
      end
    end
  end
end
