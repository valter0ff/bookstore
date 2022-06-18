# frozen_string_literal: true

RSpec.shared_examples 'order summary block have all elements' do
  it 'all elements present' do
    expect(order_summary).to have_order_subtotal_title(text: I18n.t('checkout.order_summary_table.subtotal'))
    expect(order_summary).to have_order_subtotal
    expect(order_summary).to have_coupon_title(text: I18n.t('checkout.order_summary_table.coupon'))
    expect(order_summary).to have_discount
    expect(order_summary).to have_order_total_title(text: I18n.t('checkout.order_summary_table.order_total'))
    expect(order_summary).to have_order_total
  end
end
