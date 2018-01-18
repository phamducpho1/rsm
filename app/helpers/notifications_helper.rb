module NotificationsHelper
  def check_notify notification
    if notification.event.kind_of? Job
      @link = job_path notification.event, notify_id: notification.id
    elsif notification.event.kind_of? Apply
      @link = employers_job_apply_path notification.event_job,
        id: notification.event_id, notify_id: notification.id
    end
  end

  def notify_counter notify
    if notify.present?
      notify.size
    else
      Settings.not_notify
    end
  end
end
