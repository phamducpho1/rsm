module EmployersHelper

  def show_status apply
    case
    when apply.review_passed? || apply.test_passed? || apply.interview_passed?
      Settings.primary
    when apply.review_not_selected? || apply.test_not_selected? || apply.interview_not_selected?
      Settings.danger
    when apply.offer_declined?
      Settings.warning
    when apply.joined?
      Settings.success
    else
      Settings.info
    end
  end

  def show_status_apply apply
    content_tag :span, I18n.t("employers.applies.statuses.#{apply.status}"), class: "label label-#{show_status(apply)}"
  end

  def url_image apply
    apply.user ? apply.user.picture.url : "user_avatar_default.png"
  end

  def show_image_apply apply
    image_tag url_image(apply), class: "img-circle img-avatar"
  end

  def get_status is_interview_scheduled
    is_interview_scheduled ? Apply.statuses.keys[6] : Apply.statuses.keys[3]
  end

  def show_time time
    return if time.blank?
    I18n.l time.to_s.to_datetime, format: :format_datetime
  end

  def filter_object object
    object.id.blank?
  end

  def show_progress_status_apply current_step, step, company_steps_by_step
    current_priority = company_steps_by_step[current_step.id].first.priority
    step_priority = company_steps_by_step[step.id].first.priority
    return Settings.completed if current_priority > step_priority ||
      @current_apply_status.status_step.is_status?(Settings.accepted)
    return if current_priority != step_priority
    return Settings.danger if @current_apply_status.status_step.is_status?(Settings.not_selected) ||
      @current_apply_status.status_step.is_status?(Settings.decline)
    return Settings.warning if @current_apply_status.status_step.is_status?(Settings.pending)
    Settings.active
  end

  def show_value current_step, step
    name = if current_step == step
      @current_apply_status.status_step.code
    else
      step.name
    end
    t "employers.applies.statuses.#{name}"
  end
end
