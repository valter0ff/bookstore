# frozen_string_literal: true

class AddressesController < ClientController
  rescue_from ActiveRecord::SubclassNotFound, with: :subclass_not_found
  before_action :authenticate_user!
  before_action :init_addresses
  before_action :set_address, only: %i[create update]

  def new; end

  def create
    if @address.save
      redirect_to new_address_path, notice: I18n.t('addresses.create.success')
    else
      set_address_for_form
      render :new
    end
  end

  def update
    if @address.update(address_params)
      redirect_to new_address_path, notice: I18n.t('addresses.update.success')
    else
      set_address_for_form
      render :new
    end
  end

  private

  def init_addresses
    @billing_address = current_user.billing_address || BillingAddress.new
    @shipping_address = current_user.shipping_address || ShippingAddress.new
  end

  def set_address
    @address = Address.find_by(id: params[:id]) || Address.new(address_params)
  end

  def set_address_for_form
    instance_variable_set("@#{@address.type.underscore}", @address)
  end

  def address_params
    params.require(:address).permit(:first_name, :last_name, :address,
                                    :city, :country_code, :zip, :phone, :type, :user_account_id)
  end

  def subclass_not_found
    flash[:error] = I18n.t('addresses.errors.type_not_allowed')
    redirect_to action: :new
  end
end
