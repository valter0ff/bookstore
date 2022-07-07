class AddSalesCountToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :sales_count, :integer, default: 0
  end
end
