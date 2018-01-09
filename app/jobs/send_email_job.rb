class SendEmailJob < ApplicationJob
  queue_as :default

  def perform inforappointment, apply, company
    @inforappointment = inforappointment
    @company = company
    @apply = apply
    CompanyMailer.interview_scheduled_interviewer(@inforappointment, @company, @apply).deliver_later
  end
end
