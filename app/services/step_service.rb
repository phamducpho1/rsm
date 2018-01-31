class StepService
  def initialize step, apply
    @step = step
    @status_step_ids = @step.status_steps.pluck(:id)
    @apply = apply
    @apply_statuses = @apply.apply_statuses.lastest_apply_status.is_step @status_step_ids
    @apply_status_lastest = @apply_statuses.first
  end

  def get_data_step
    {
      apply_status_lastest: @apply_status_lastest,
      appointment: @apply_status_lastest.appointment,
      email_sents: @apply_status_lastest.email_sents
    }
  end
end
