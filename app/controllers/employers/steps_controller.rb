class Employers::StepsController < Employers::EmployersController
  before_action :load_apply, :load_history_apply_status, :load_status_step_scheduled

  def show
    @status_steps = @step.status_steps
    respond_to do |format|
      format.js
    end
  end

  private

  def load_history_apply_status
    step_service = StepService.new @step, @apply
    @apply_status = step_service.apply_status_lastest || build_apply_status
    @data_step = step_service.get_data_step
  end

  def build_apply_status
    @status_step_id = @step.status_steps.pluck(:id).first
    @apply.apply_statuses.build status_step_id: @status_step_id
  end
end
