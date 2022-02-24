class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :description
      t.integer :year_publication
      t.float :height
      t.float :width
      t.float :depth
      t.float :price
      t.integer :quantity
      t.references :category, null: false, foreign_key: true
      t.index :title

      t.timestamps
    end
  end
end
