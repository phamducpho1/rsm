class Employers::AppliesController < Employers::EmployersController
  before_action :load_notify, only: :show
  before_action :readed_notification, only: :show
  before_action :load_notifications, only: %i(show index)
  before_action :get_step_by_company, :load_current_step, :load_next_step,
    :build_apply_statuses, :load_status_step_scheduled,
    :load_statuses_by_current_step, only: :show

  def index
    applies = @company.applies
    @size_statuses = SelectApply.caclulate_applies applies,
      Settings.caclulate_applies_size
    @q = applies.search params[:q]
    @applies = @q.result.lastest_apply
      .page(params[:page]).per Settings.applies_max
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
