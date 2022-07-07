class AddStepAndJsonColumnsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :step, :integer, default: 0
    add_column :orders, :shipping_address, :jsonb, default: '{}'
    add_column :orders, :billing_address, :jsonb, default: '{}'
    add_column :orders, :shipping_price, :float, null: true
    add_column :orders, :completed_at, :datetime, precision: 6
  end
end
