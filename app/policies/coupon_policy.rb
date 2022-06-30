# frozen_string_literal: true

class CouponPolicy < ApplicationPolicy
  def destroy?
    record.active?
  end

  def destroy_all?
    destroy?
  end
end
