class AddOmniauthToUserAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :user_accounts, :provider, :string
    add_column :user_accounts, :uid, :string
  end
end
