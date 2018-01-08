class AppliesController < ApplicationController
  load_and_authorize_resource param_method: :apply_params

  def index
    @applies = current_user.applies.includes(:job, :company).newest_apply
      .page(params[:page]).per(Settings.apply.page)
  end

  def show; end

  def create
    @apply.cv = current_user.cv if params[:checkcv].blank? && user_signed_in?
    @apply.information = params[:apply][:information].permit!.to_h
    format_respond
  end

  private

  def apply_params
    params.require(:apply).permit :status, :user_id, :job_id, :information, :cv
  end

  def format_respond
    respond_to do |format|
      if @apply.save
        @apply.save_activity current_user, :create
        AppliesUserJob.perform_later @apply
        AppliesEmployerJob.perform_later @apply
        format.js{flash.now[:success] = t "apply.applied"}
      else
        format.js
      end
    end
  end
end
