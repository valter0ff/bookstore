# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_account_update_params, only: :update
    before_action :build_resource_auto, only: :fast_sign_up
    #
    #     def checkout_login
    #       self.resource = @resource || UserAccount.new
    #       redirect_to checkout_address_path if user_signed_in?
    #     end

    def fast_sign_up
      if resource.save
        set_flash_message! :notice, :signed_up
        resource.send_reset_password_instructions
        sign_in(resource_name, resource)
        redirect_to after_sign_in_path_for(resource)
      else
        #         render :checkout_login
        render 'checkouts/login'
      end
    end

    protected

    def update_resource(resource, params)
      if params[:password].present? || params[:current_password].present? || params[:password_confirmation].present?
        resource.update_with_password(params)
      else
        params.delete(:current_password)
        resource.update_without_password(params)
      end
    end

    def after_update_path_for(_resource)
      edit_user_registration_path
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [picture_attributes: %i[id image _destroy]])
    end

    def build_resource_auto
      self.resource = build_resource(email: params[resource_name][:email], password: generate_password)
    end

    def generate_password
      Devise.friendly_token.first(8) + rand(10).to_s
    end
  end
end
