class StepService
  attr_reader :apply_status_lastest

  def initialize step, apply
    @step = step
    @status_step_ids = @step.status_steps.pluck(:id)
    @apply = apply
    @apply_statuses = @apply.apply_statuses.lastest_apply_status.is_step @status_step_ids
    @apply_status_lastest = @apply_statuses.first
    @email_sents = get_email_sents
    @appointment = get_appointment
  end

  def get_data_step
    return {} if @apply_status_lastest.blank?
    {
      appointment: @appointment,
      email_sents: @email_sents,
      dates: dates
    }
  end

  def dates
    dates = if @appointment.present?
      @email_sents.keys << @appointment.created_at.to_s.to_date
    else
      @email_sents.keys
    end
    dates.uniq.sort
  end

  def get_appointment
    return if @apply_status_lastest.blank?
    @apply_status_lastest.appointment
  end

  def get_email_sents
    return {} if @apply_statuses.blank?
    @apply_status_lastest.email_sents.group_by {|email| email.created_at.to_s.to_date}
  end
end
