# frozen_string_literal: true

class CreditCardDecorator < ApplicationDecorator
  delegate_all

  def masked_number
    number[-4..-1].prepend('** ** ** ')
  end

  def expiry_date_full_year
    Date.strptime(expiry_date, '%m/%y').strftime('%m/%Y')
  end
end
