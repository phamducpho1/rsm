class SendEmailUserJob < ApplicationJob
  queue_as :default

  def perform content, company, title, email
    @content = content
    @company = company
    @title = title
    @email = email
    CompanyMailer.send_mailer_candidate(@content, @company, @title, @email).deliver_later
  end
end
