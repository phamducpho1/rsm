class Employers::AppliesController < Employers::EmployersController
  before_action :load_notify, only: :show
  before_action :readed_notification, only: :show
  before_action :load_notifications, only: %i(show index)
  before_action :get_step_by_company, :load_current_step, :load_next_step,
    :build_apply_statuses, :load_status_step_scheduled,
    :load_statuses_by_current_step, only: :show

  def index
    @q = Apply.search params[:q]
    applies = Apply.newest_apply
    @size_applies = applies.size
    @applies_status = applies.group_by &:status
    @applies = @q.result.page(params[:page]).per Settings.applies_max
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    respond_to do |format|
      format.js
      format.html
    end
  end
end
