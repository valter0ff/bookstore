# frozen_string_literal: true

class CouponPolicy < ApplicationPolicy
  def update?
    record.active?
  end

  def destroy?
    update?
  end
end
