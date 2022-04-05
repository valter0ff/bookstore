# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :init_addresses, only: %i[new create]

  def new; end

  def create
    @address = build_address_with_params
    if @address.save
      redirect_to new_address_path, notice: I18n.t('address.flash.success')
    else
      render :new
    end
  end

  private

  def init_addresses
    @billing_address = current_user.billing_address || BillingAddress.new
    @shipping_address = current_user.shipping_address || ShippingAddress.new
  end

  def build_address_with_params
    instance_variable_set("@#{address_type}", address_class_name.new(address_params))
  end

  def address_type
    (params.keys & permitted_address_types.map(&:underscore)).first
  end

  def address_class_name
    address_type.camelize.constantize
  end

  def address_params
    params.require(address_type).permit(:first_name, :last_name, :address,
                                        :city, :country_code, :zip, :phone, :type, :user_account_id)
  end

  def permitted_address_types
    Address.subclasses.map(&:name)
  end
end
