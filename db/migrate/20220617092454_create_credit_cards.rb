class CreateCreditCards < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_cards do |t|
      t.bigint :number, null: false
      t.string :holder_name, null: false
      t.string :expiry_date, null: false
      t.integer :cvv_code, null: false
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
