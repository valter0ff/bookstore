# frozen_string_literal: true

RSpec.shared_examples 'cart items table have all elements' do
  it 'all headers present' do
    expect(table_headers).to have_book_label(text: I18n.t('checkout.cart_items.book'))
    expect(table_headers).to have_price_label(text: I18n.t('checkout.cart_items.price'))
    expect(table_headers).to have_quantity_label(text: I18n.t('checkout.cart_items.quantity'))
    expect(table_headers).to have_subtotal_label(text: I18n.t('checkout.cart_items.subtotal'))
  end

  it 'all elements present with correct values' do
    expect(cart_item_block).to have_book_image
    expect(cart_item_block).to have_book_title(text: decorated_cart_item.book.title)
    expect(cart_item_block).to have_book_description(text: decorated_cart_item.book.short_description)
    expect(cart_item_block).to have_book_price(text: decorated_cart_item.book_price_with_currency)
    expect(cart_item_block).to have_book_quantity(text: decorated_cart_item.books_count)
    expect(cart_item_block).to have_subtotal_price(text: decorated_cart_item.subtotal_price)
  end
end
