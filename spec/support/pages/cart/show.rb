# frozen_string_literal: true

module Pages
  module Cart
    class Show < SitePrism::Page
      set_url '/cart'

      element :cart_icon, '.shop-icon .shop-quantity'
      element :checkout_button, '.hidden-xs.checkout'
      element :flash_notice, '#flash_notice'
      element :flash_alert, '#flash_alert'

      section :cart_items_table, '.hidden-xs.cart-items-table' do
        section :table_headers, '.table-hover' do
          element :product_header, '.in-grey-600.product'
          element :price_header, '.in-grey-600.price'
          element :quantity_header, '.in-grey-600.quantity'
          element :subtotal_header, '.in-grey-600.sub-total'
        end

        sections :cart_item, 'tr[class^=cart_item]' do
          element :product_image, '.cart-img-shadow.pull-left'
          element :product_title, 'p.title>a'
          element :product_price, '.in-gold-500.price'
          element :decrement_button, '.decrement-book'
          element :quantity_input, '.quantity-input'
          element :increment_button, '.increment-book'
          element :subtotal_price, '.in-gold-500.subtotal'
          element :delete_button, 'a.close.general-cart-close'
        end
      end

      section :coupon_form, '.coupon-form' do
        element :code_input_label, '.code-label'
        element :code_input_field, '.code-field'
        element :submit_button, '.btn.submit-coupon'

        def apply_coupon(coupon_code)
          code_input_field.set(coupon_code)
          submit_button.click
        end
      end

      section :order_summary, '.order-summary' do
        element :order_summary_title, '.order-summary-title'
        element :order_subtotal_title, '.order-subtotal-title'
        element :order_subtotal, '.order-subtotal'
        element :coupon_title, '.coupon-title'
        element :discount, '.discount'
        element :order_total_title, '.order-total-title'
        element :order_total, '.order-total'
      end
    end
  end
end
