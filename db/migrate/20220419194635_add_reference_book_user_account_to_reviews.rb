class AddReferenceBookUserAccountToReviews < ActiveRecord::Migration[6.1]
  def change
    add_reference :reviews, :user_account, null: false, foreign_key: true
    add_column :reviews, :status, :integer, default: 0
  end
end
