class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user_account, null: true, foreign_key: true
      t.references :coupon, null: true, foreign_key: true
      t.datetime :delivered_at, precision: 6
      t.datetime :in_delivery_at, precision: 6
      t.integer :state, default: 0
      t.string :number

      t.timestamps
    end
  end
end
