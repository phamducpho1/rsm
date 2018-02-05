class StepService
  attr_reader :apply_status_lastest, :status_step_lastest,
    :step, :apply_status_current_step, :is_current_step

  def initialize step_current, apply, company
    @is_current_step = true
    @company = company
    @apply = apply
    @step = get_step step_current
    @company_step = get_company_step @step
    @status_step_ids = @step.status_steps.pluck(:id)
    @apply_statuses = @apply.apply_statuses.lastest_apply_status.includes(:status_step).is_step @status_step_ids
    @apply_status_lastest = @apply_statuses.first
    @status_step_lastest = get_status_step
    @email_sents = get_email_sents
    @appointment = get_appointment
    @apply_status_current_step ||= @apply_status_lastest
  end

  def get_data_step
    return {} if @apply_status_lastest.blank?
    {
      is_current_step: @is_current_step,
      apply_status_lastest: @apply_status_lastest,
      company_step: @company_step,
      status_step_lastest: @status_step_lastest,
      appointment: @appointment,
      email_sents: @email_sents,
    }
  end

  def get_appointment
    return if @apply_status_lastest.blank?
    @apply_status_lastest.appointment
  end

  def get_status_step
    return if @apply_status_lastest.blank?
    @apply_status_lastest.status_step
  end

  def get_email_sents
    return {} if @apply_statuses.blank?
    @apply_status_lastest.email_sents.includes :user
  end

  def get_step step_current
    company_step = get_company_step step_current
    return step_current if company_step.is_first_company_step?
    status_step_ids = step_current.status_steps.pluck(:id)
    apply_statuses = @apply.apply_statuses.lastest_apply_status.includes(:status_step).is_step status_step_ids
    @apply_status_current_step =  apply_statuses.first
    return step_current unless @apply_status_current_step.status_step.is_status?(Settings.pending)
    @is_current_step = !@is_current_step
    company_step.load_step @company, Settings.prev_step
  end

  def get_apply_statuses
    @step = @company_step.load_step @company, Settings.prev_step
  end

  def get_company_step step_current
    step_current.company_steps.find_by company_id: @company.id
  end
end
