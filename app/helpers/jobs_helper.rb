module JobsHelper
  def display_company_banner company
    image_tag(company.banner.url) if company.banner.url.present?
  end

  def information_job job, commany
    [t("recruit", company: commany.name), "\n"+ job.name, "\n"+
      t("jobs.show.salary") + job.max_salary.round.to_s + Settings.currency.dollar]
  end

  def options_position_types
    Job.position_types.map { |k,v| [t(".#{k}"), v ] }
  end

  def options_of_selectbox options, param_q, field_search
    value_selected = param_q.present? ? param_q[field_search] : ""
    options_for_select options, value_selected
  end

  def address_of_branch branch
    address = branch.street
    address.concat(", #{branch.ward}") if branch.ward.present?
    address.concat(", #{branch.district}") if branch.district.present?
    address.concat(", #{branch.province}") if branch.province.present?
    address.concat(", #{branch.country}") if branch.country.present?
    address.squish
  end

  def count_applies job
    job.applies.size
  end

  def dashboard_css job
    if (load_value job) < Settings.job.width
      Settings.job.width
    else
      load_value job
    end
  end

  def class_dashboard job
    case load_value job
    when Settings.job.sixty..Settings.job.hundred
      "success"
    when Settings.job.fourty..Settings.job.sixteen
      "info"
    when Settings.job.twenty..Settings.job.fourteen
      "warning"
    else
      "danger"
    end
  end

  def load_value job
    (job.applies.joined.size/(job.target.to_f)*Settings.job.hundred).to_i
  end

  def count_page counter, page
    counter + CouterIndex.couter(@page, Settings.job.page)
  end
end
