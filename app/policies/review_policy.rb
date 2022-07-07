# frozen_string_literal: true

class ReviewPolicy < ApplicationPolicy
  def approve?
    record.unprocessed?
  end

  def reject?
    record.unprocessed?
  end
end
