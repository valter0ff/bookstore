# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :init_addresses
  before_action :find_address, only: :update

  def new; end

  def create
    @address = build_address_with_params
    if @address.save
      redirect_to new_address_path, notice: I18n.t('addresses.create.success')
    else
      render :new
    end
  end

  def update
    set_address_for_form
    if @address.update(address_params)
      redirect_to new_address_path, notice: I18n.t('addresses.update.success')
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

  def set_address_for_form
    instance_variable_set("@#{@address.type.underscore}", @address)
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

  def find_address
    @address = Address.find(params[:id])
  end
end
