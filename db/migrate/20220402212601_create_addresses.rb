class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :address, null: false, limit: 50
      t.string :city, null: false, limit: 50
      t.string :zip, null: false, limit: 10
      t.string :country_code, null: false, limit: 50
      t.string :phone, null: false, limit: 15
      t.string :type, null: false
      t.references :user_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
