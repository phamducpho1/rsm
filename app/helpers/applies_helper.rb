module AppliesHelper
  def get_data appointments, apply
    content_tag "div", id: "apply-appointments", data: {events: appointments, name: get_name_to(apply) }{}
  end

  def get_name_to apply
    apply.information[:name] || ''
  end
end
