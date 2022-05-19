class RemoveNullForUserAndCouponInOrder < ActiveRecord::Migration[6.1]
  def change
    change_column_null :orders, :user_account_id, true
    change_column_null :orders, :coupon_id, true
  end
end
