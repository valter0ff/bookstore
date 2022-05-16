FactoryBot.define do
  factory :order do
    user_account { nil }
    coupon { nil }
    step { 1 }
  end
end
