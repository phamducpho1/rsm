class UsersController < ApplicationController
  before_action :load_user, only: %i(show)

  def show; end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "users_controller.errors"
    redirect_to root_url
  end
end
