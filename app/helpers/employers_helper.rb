module EmployersHelper

  def show_status apply
    case
    when apply.review_passed? || apply.test_passed? || apply.interview_passed?
      "primary"
    when apply.review_not_selected? || apply.test_not_selected? || apply.interview_not_selected?
      "danger"
    when apply.offer_declined?
      "warning"
    when apply.joined?
      "success"
    else
      "info"
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

  def show_progress_status_apply apply, status, index
    if apply.status.include? status
      @max_status = true
      return "completed" if @apply.joined?
      return "danger" if apply.review_not_selected? || apply.test_not_selected? ||
        apply.interview_not_selected? || @apply.offer_declined?
      "active"
    else
      @max_status.present? ? "" : "completed"
    end
  end
end
