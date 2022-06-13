class CreateShippingMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_methods do |t|
      t.string :name, null: false
      t.integer :days, default: 0
      t.float :price, default: 0

      t.timestamps
    end
  end
end
