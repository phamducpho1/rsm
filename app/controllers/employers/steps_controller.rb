class Employers::StepsController < Employers::EmployersController
  before_action :load_apply, :load_history_apply_status

  def show
    @status_steps = @step.status_steps
    respond_to do |format|
      format.js
    end
  end

  private

  def load_apply
    @apply = Apply.find_by id: params[:apply_id]
    return if @apply
    redirect_to root_url
  end

  def load_history_apply_status
    step_service = StepService.new @step, @apply
    @data_step = step_service.get_data_step
  end
end
