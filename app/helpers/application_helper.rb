module ApplicationHelper

  def full_title page_title = ""
    base_title = I18n.t("app")
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def branches_footer branches
    render branches
  end

  def header_title title = ""
    title
  end

  def define_style_placeholder list
    Settings.placeholder.display_none if list.present?
  end

  def show_errors object, name_attribute, name_error
    messages = object.errors.messages[name_attribute]
    return "#{messages[0]}" if messages.present?
  end

  def get_value_user object, user
    object.id.present? ? object.user_id : user.id
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def flash_class level
    case level
    when :notice then "alert-info"
    when :error then "alert-danger"
    when :alert then "alert-warning"
    when :success then "alert-success"
    end
  end

  def check_index position
    position % Settings.dashboard.mod == Settings.dashboard.zero ? "dark-light" : ""
  end
end
