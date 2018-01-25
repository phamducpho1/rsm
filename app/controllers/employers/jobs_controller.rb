class Employers::JobsController < Employers::EmployersController
  before_action :create_job, only: %i(index new)
  before_action :load_jobs, only: :index
  before_action :load_applies_joined_by_jobs, only: :index
  before_action :load_branches_for_select_box, only: :index
  before_action :load_category_for_select_box, only: :index
  def show
    @appointment = @company.appointments.build
    @applies = @job.applies.page(params[:page]).per Settings.apply.page
    @apply_statuses = ApplyStatus.includes(:status_step).current.get_by(@applies.pluck(:id)).group_by &:apply_id
  end

  def create
    respond_to do |format|
      if @job.save
        format.js{ @message = t "job_created"}
      else
        format.js
      end
    end
    load_jobs
  end

  def index
    @search = @company.jobs.includes(:applies).search params[:q]
    @jobs = @search.result(distinct: true).sort_lastest
      .page(params[:page]).per Settings.job.page
    @page = params[:page]
  end

  def destroy
    respond_to do |format|
      if @job.destroy
        format.js{@message = t "deleted_job"}
      else
        format.js
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @job.update_attributes job_params
        format.js{@message = t "job_updated"}
      else
        format.js
      end
    end
    load_jobs
  end

  private

  def create_job
    @job = @company.jobs.new user_id: current_user.id
  end

  def job_params
    params.require(:job).permit(:content, :name, :level, :language, :target,
      :skill, :position, :company_id, :description, :min_salary, :max_salary,
      :branch_id, :category_id, reward_benefits_attributes: %i(id content job_id _destroy))
      .merge! user_id: current_user.id
  end

  def load_jobs
    @jobs = @company.jobs.includes(:applies).sort_lastest.page(params[:page]).per Settings.job.page
  end

  def load_applies_joined_by_jobs
    @applies_by_jobs = @company.applies.joined.group_by &:job_id
  end

  def load_branches_for_select_box
    @provinces ||= @company.branches.by_status(Branch.statuses[:active]).order_is_head_office_and_province_desc.pluck :province, :id
  end

  def load_category_for_select_box
    @categories ||= @company.categories.by_status(Category.statuses[:active]).order_name_desc.pluck :name, :id
  end
end
