class SendEmailUserJob < ApplicationJob
  queue_as :default

  def perform title, apply, template, company
    @title = title
    @apply = apply
    @template = template
    @company = company
    CompanyMailer.interview_scheduled_candidate(@title, @apply, @template, @company).deliver_later
  end
end
