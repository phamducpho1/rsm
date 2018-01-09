module AppliesHelper
  def get_data appointments
    content_tag "div", id: "apply-appointments", data: {events: appointments}{}
  end
end
