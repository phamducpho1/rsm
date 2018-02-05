class Employers::StepsController < Employers::EmployersController
  before_action :load_apply, :load_current_step,
    :load_history_apply_status, :load_status_step_scheduled

  def show
    respond_to do |format|
      format.js
    end
  end

  private

  def load_history_apply_status
    step_service = StepService.new @step, @apply, @company
    @apply_status = step_service.apply_status_lastest || build_apply_status
    @status_step = step_service.status_step_lastest
    @status_steps = step_service.step.status_steps
    @data_step = step_service.get_data_step
    get_data step_service
  end

  def build_apply_status
    @status_step_id = @step.status_steps.pluck(:id).first
    @apply.apply_statuses.build status_step_id: @status_step_id
  end

  def get_data step_service
    if !step_service.is_current_step
      @apply_status = step_service.apply_status_current_step || build_apply_status
      @status_steps = @step.status_steps
    end
  end
end
