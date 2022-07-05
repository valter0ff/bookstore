# frozen_string_literal: true

module Pages
  module Orders
    class Index < SitePrism::Page
      set_url '/orders'

      element :page_title, '.general-page-title'
      element :filter_title, '.filter-title'
      element :filter_dropdown, '.filter-dropdown'

      section :orders_table, '.orders-table' do
        section :table_headers, '.orders-table-headers' do
          element :number_title, '.number-title'
          element :completed_title, '.completed-title'
          element :status_title, '.status-title'
          element :total_title, '.total-title'
        end

        sections :order_items, '.order-item' do
          element :link_to_order, '.general-order-number'
          element :completed_at, '.completed-at'
          element :status, '.status'
          element :price, '.price'
        end
      end
    end
  end
end
