class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons do |t|
      t.string :code, null: false, index: { unique: true }
      t.integer :discount, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
