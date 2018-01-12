class Devises::RegistrationsController < Devise::RegistrationsController
  layout "devise_users/devise_user"

  def create
    if request.xhr?
      build_resource sign_up_params
      if resource.save
        set_flash_message :notice, :signed_up
        sign_up resource_name, resource
        render js: "window.location = '#{after_sign_up_path_for resource}'"
      else
        clean_up_passwords resource
        respond_to do |format|
          format.js
        end
      end
    else
      super
    end
  end

  private

  def after_sign_up_path_for resource
    stored_location_for(resource) || root_path
  end
end
