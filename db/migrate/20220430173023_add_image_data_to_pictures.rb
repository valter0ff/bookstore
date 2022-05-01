class AddImageDataToPictures < ActiveRecord::Migration[6.1]
  def change
    add_column :pictures, :image_data, :text
  end
end
