class CreateBookMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :book_materials do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :material, null: false, foreign_key: true

      t.timestamps
    end
  end
end
