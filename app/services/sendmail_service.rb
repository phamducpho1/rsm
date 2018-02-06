class SendmailService

  def initialize email_sents, company, apply = nil
    @email_sents = email_sents
    @company = company
    @apply = apply
  end

  def send_candidate
    candidate_content = @email_sents.content
    candidate_title = @email_sents.title
    candidate_email = @email_sents.receiver_email
    SendEmailUserJob.perform_later candidate_content, @company, candidate_title, candidate_email
  end

  def send_interview
    SendEmailJob.perform_later @email_sents, @company, @apply
  end
end
