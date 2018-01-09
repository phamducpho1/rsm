class Devises::SessionsController < Devise::SessionsController
  layout "devise_users/devise_user"

  def create
    if request.xhr?
      resource = warden.authenticate! scope: resource_name, recall: "#{controller_path}#failure"
      set_flash_message! :notice, :signed_in
      sign_in resource_name, resource
      render json: {success: true, link_redirect: after_sign_in_path_for(resource)}
    else
      super
    end
  end

  def failure
    if request.xhr?
      message = t("devise.failure.invalid", authentication_keys: "email")
      render json: {success: false, message: message}
    else
      super
    end
  end

  private

  def after_sign_in_path_for resource
    stored_location_for(resource) || root_path
  end
end
