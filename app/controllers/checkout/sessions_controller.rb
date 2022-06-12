# frozen_string_literal: true

module Checkout
  class SessionsController < Devise::SessionsController
    def sign_up
      @user = UserAccount.new(email: params[:user_account][:email], password: generate_password)
      if @user.save
        @user.send_reset_password_instructions
        sign_in(@user)
        redirect_to checkout_address_path, notice: I18n.t('devise.registrations.account_created')
      else
        render :new
      end
    end

    private

    def generate_password
      Devise.friendly_token.first(8) + rand(10).to_s
    end

    def after_sign_in_path_for(_resource)
      new_checkout_address_path
    end
  end
end
