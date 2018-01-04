module EmployersHelper

  def bootstrap_class_for(status)
    case status
    when "waitting"
      "label-default"
    when "reviewing"
      "label-primary"
    when "approve"
      " label-success"
    when "hired"
      "label-warning"
    when "rejected"
      "label-danger"
    else
      status.to_s
    end
  end

  def show_status_apply status
    content_tag :span, status, class: "label #{bootstrap_class_for(status)}"
  end

  def url_image apply
    apply.user ? apply.user.picture.url : "user_avatar_default.png"
  end

  def show_image_apply apply
    image_tag url_image(apply), class: "img-circle img-avatar"
  end
end
