class Employers::AppliesController < Employers::EmployersController

  before_action :load_notify, only: :show
  before_action :readed_notification, only: :show
  before_action :load_notifications, only: %i(show index)
  before_action :get_step_by_company, :load_current_step, :load_next_step,
    :load_prev_step, :build_apply_statuses, :load_status_step_scheduled,
    :load_statuses_by_current_step, :build_next_and_prev_apply_statuses, :load_apply_statuses, only: :show
  before_action :permission_employer_company, only: :create

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

  def new
    company_manager = Member.search_relation(Member.roles[:employer], current_user.id)
      .pluck :company_id
    @q = Job.job_company(company_manager).search params[:q]
    @jobs = @q.result
    @apply = Apply.new
  end

  def create
    respond_to do |format|
      if @error
          format.js{@error}
      else
        @apply.information = params[:apply][:information].permit!.to_h
        if @apply.save
          format.js{@message = t ".success"}
        else
          format.js{@error = t ".failure"}
        end
      end
    end
  end

  private

  def apply_params
    params.require(:apply).permit(:cv, :job_id)
      .merge! broker: current_user.id
  end

  def permission_employer_company
    company_manager = Member.search_relation(Member.roles[:employer], current_user.id)
      .pluck :company_id
    @apply = Apply.new apply_params
    if @apply.job_id
      return if !@apply.user_id && company_manager.include?(@apply.job.company_id)
      @error = t "company_mailer.fail"
    else
      @error = t ".job_nil"
    end
  end
end
