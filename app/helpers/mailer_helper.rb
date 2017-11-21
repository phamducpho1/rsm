module MailerHelper
  def check_mail value_mail
    value_mail.pending_reconfirmation? ? value_mail.unconfirmed_email : value_mail.email
  end
end
