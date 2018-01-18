module AppliesHelper
  def get_data appointments, apply
    content_tag "div", id: "apply-appointments", data: {events: appointments, name: get_name_to(apply) }{}
  end

  def get_name_to apply
    apply.information[:name] || ''
  end

  def percent_status size_applies, total
    ((size_applies.to_f / total) * Settings.percent).round Settings.rounding
  end
end
