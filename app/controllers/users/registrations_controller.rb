# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def update_resource(resource, params)
      if params[:current_password].blank? && params[:email].present?
        resource.update_without_password(params)
      else
        resource.update_with_password(params)
      end
    end

    def after_update_path_for(resource)
      edit_user_registration_path(resource)
    end
  end
end
