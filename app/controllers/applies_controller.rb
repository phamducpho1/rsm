class AppliesController < ApplicationController
  load_and_authorize_resource param_method: :apply_params

  def index
    respond_to do |format|
      @q = current_user.applies.includes(:job, :company).ransack params[:q]
      @applies = @q.result(distinct: true).newest_apply.page(params[:page]).per(Settings.apply.page).to_a.uniq
      format.js
    end
  end

  def show; end

  def create
    if user_signed_in? && current_user.cv.present?
      @apply.cv = current_user.cv if params[:radio] == Settings.apply.checked
    end
    @apply.information = params[:apply][:information].permit!.to_h
    format_respond
  end

  private

  def apply_params
    params.require(:apply).permit :status, :user_id, :job_id, :information, :cv, :broker
  end

  def format_respond
    respond_to do |format|
      if @apply.save
        create_activity_notify
        AppliesUserJob.perform_later @apply
        AppliesEmployerJob.perform_later @apply
        format.js{flash.now[:success] = t "apply.applied"}
      else
        format.js
      end
    end
  end

  def create_activity_notify
    @apply.save_activity :create, current_user
    Notification.create_notification :employer, @apply, current_user, @apply.job.company_id
  end
end
