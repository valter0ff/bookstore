class AddStepAndJsonColumnsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :step, :integer, default: 0
    add_column :orders, :shipping_address, :jsonb, default: '{}'
    add_column :orders, :billing_address, :jsonb, default: '{}'
    add_column :orders, :all_cart_items, :jsonb, default: '{}'
    add_column :orders, :total_price, :string, null: true
  end
end
