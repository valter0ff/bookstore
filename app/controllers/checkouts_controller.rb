# frozen_string_literal: true

class CheckoutsController < Devise::SessionsController
  before_action :authenticate_on_checkout, except: %i[new create fast_sign_up]

  def fast_sign_up
    @user = UserAccount.new(email: params[:user_account][:email], password: generate_password)
    if @user.save
      @user.send_reset_password_instructions
      sign_in(@user)
      redirect_to checkout_address_path, notice: I18n.t('devise.registrations.account_created')
    else
      render :new
    end
  end

  def address; end

  private

  def authenticate_on_checkout
    redirect_to checkout_login_path unless user_signed_in?
  end

  def generate_password
    Devise.friendly_token.first(8) + rand(10).to_s
  end

  def after_sign_in_path_for(_resource)
    checkout_address_path
  end
end
