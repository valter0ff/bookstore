# frozen_string_literal: true

describe OrderDecorator do
  subject(:decorated_order) { described_class.new(order) }

  describe '#subtotal_price' do
    let(:order) { create(:order, cart_items: cart_items) }
    let(:cart_items) { create_list(:cart_item, rand(3..10)) }
    let(:cart_items_price) { decorated_order.cart_items.sum(&:subtotal_value) }
    let(:expected_price) { decorated_order.send(:price_with_currency, cart_items_price) }

    it 'returns sum of cart items book`s prices with currency' do
      expect(decorated_order.subtotal_price).to eq(expected_price)
    end
  end

  describe '#discount' do
    context 'when order have coupon associated' do
      let(:order) { create(:order) }
      let(:discount_value) { order.coupon.discount }
      let(:discount_with_currency) { decorated_order.send(:price_with_currency, discount_value) }

      it 'returns coupon discount value with currency' do
        expect(decorated_order.discount).to eq(discount_with_currency)
      end
    end

    context 'when order not have coupon' do
      let(:order) { create(:order, coupon: nil) }
      let(:discount_with_currency) { decorated_order.send(:price_with_currency, 0) }

      it 'returns zero with currency' do
        expect(decorated_order.discount).to eq(discount_with_currency)
      end
    end
  end

  describe '#total_price' do
    let(:order) { create(:order, cart_items: cart_items, coupon: coupon) }
    let(:cart_items) { create_list(:cart_item, rand(3..10)) }
    let(:expected_price) { decorated_order.send(:price_with_currency, total_value) }

    context 'when sum of book`s prices larger tnen discount' do
      let(:coupon) { create(:coupon, discount: rand(1..10)) }
      let(:cart_items_price) { decorated_order.cart_items.sum(&:subtotal_value) }
      let(:total_value) { cart_items_price - order.coupon.discount }

      it 'returns result of subtraction discount from sum of book`s prices with currency' do
        expect(decorated_order.total_price).to eq(expected_price)
      end
    end

    context 'when sum of book`s prices less tnen discount' do
      let(:coupon) { create(:coupon, discount: rand(10_000..20_000)) }
      let(:total_value) { 0 }

      it 'returns zero with currency' do
        expect(decorated_order.total_price).to eq(expected_price)
      end
    end
  end

  describe '#shipping_amount' do
    context 'when shipping_price attribute filled' do
      let(:order) { create(:order, :completed) }
      let(:shipping_price) { order.shipping_price }
      let(:shipping_price_with_currency) { decorated_order.send(:price_with_currency, shipping_price) }

      it 'returns shipping_price value with currency' do
        expect(decorated_order.shipping_amount).to eq(shipping_price_with_currency)
      end
    end

    context 'when shipping_price attribute blank' do
      let(:order) { create(:order, :filled) }
      let(:shipping_price) { order.shipping_method.price }
      let(:shipping_method_price_with_currency) { decorated_order.send(:price_with_currency, shipping_price) }

      it 'returns shipping method pricewith currency' do
        expect(decorated_order.shipping_amount).to eq(shipping_method_price_with_currency)
      end
    end

    context 'when there is no shipping_price and no shipping_method associated' do
      let(:order) { create(:order) }
      let(:shipping_amount_with_currency) { decorated_order.send(:price_with_currency, 0) }

      it 'returns zero with currency' do
        expect(decorated_order.shipping_amount).to eq(shipping_amount_with_currency)
      end
    end
  end

  describe '#total_with_shipping' do
    let(:order) { create(:order, :filled, cart_items: cart_items, coupon: coupon) }
    let(:cart_items) { create_list(:cart_item, rand(3..10)) }
    let(:expected_price) { decorated_order.send(:price_with_currency, total_value) }

    context 'when sum of book`s prices with shipping price larger tnen discount' do
      let(:coupon) { create(:coupon, discount: rand(1..10)) }
      let(:cart_items_price) { decorated_order.cart_items.sum(&:subtotal_value) }
      let(:shipping_method_price) { decorated_order.send(:shipping_method_price) }
      let(:total_value) { cart_items_price + shipping_method_price - order.coupon.discount }

      it 'returns result of subtraction discount from sum of book`s prices with currency' do
        expect(decorated_order.total_with_shipping).to eq(expected_price)
      end
    end

    context 'when sum of book`s prices with shipping price less tnen discount' do
      let(:coupon) { create(:coupon, discount: rand(10_000..20_000)) }
      let(:total_value) { 0 }

      it 'returns zero with currency' do
        expect(decorated_order.total_with_shipping).to eq(expected_price)
      end
    end
  end

  describe '#complete_date' do
    let(:order) { create(:order, :completed) }
    let(:expected_result) { order.completed_at.strftime('%B %d, %Y') }

    it 'returns formatted `completed_at` date' do
      expect(decorated_order.complete_date).to eq(expected_result)
    end
  end

  describe '#from_json_shipping_address' do
    let(:shipping_address) { create(:shipping_address) }
    let(:order) { create(:order, shipping_address:  shipping_address.to_json) }

    it 'returns Address model object with corresponding values' do
      expect(decorated_order.from_json_shipping_address).to eq(shipping_address)
    end
  end
end
