# frozen_string_literal: true

module Checkout
  class SessionsController < Devise::SessionsController
    def sign_up
      @user = UserAccount.new(email: permitted_params[:email], password: generate_password)
      if @user.save
        @user.send_reset_password_instructions
        sign_in(@user)
        set_order
        redirect_to edit_checkout_address_path, notice: I18n.t('devise.registrations.account_created')
      else
        render :new
      end
    end

    private

    def permitted_params
      params.require(:user_account).permit(:email)
    end

    def generate_password
      Devise.friendly_token.first(8) + rand(10).to_s
    end

    def after_sign_in_path_for(_resource)
      set_order if check_order
      edit_checkout_address_path
    end
  end
end
