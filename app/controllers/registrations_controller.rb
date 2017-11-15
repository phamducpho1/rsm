class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    params[:user][:birthday] = Date.strptime(params[:user][:birthday], "%m/%d/%Y") if params[:user][:birthday].present?
    super
  end

  def edit
    super
  end

  def update
    super
  end
end
