class AddUseBillingAddressFieldToUserAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :user_accounts, :use_billing_address, :boolean, default: false
  end
end
