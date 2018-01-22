class SendEmailUserJob < ApplicationJob
  queue_as :default

  def perform title, apply, template, company, apply_status
    @title = title
    @apply = apply
    @template = template
    @company = company
    @apply_status = apply_status
    CompanyMailer.interview_scheduled_candidate(@title, @apply,
      @template, @company, @apply_status).deliver_later
  end
end
