# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_account_update_params, only: :update

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
  end
end
