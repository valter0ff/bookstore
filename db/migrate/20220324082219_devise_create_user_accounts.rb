# frozen_string_literal: true

class DeviseCreateUserAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :user_accounts do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :user_accounts, :email,                unique: true
    add_index :user_accounts, :reset_password_token, unique: true
  end
end
