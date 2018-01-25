class Supports::Dashboard
  attr_reader :company, :params_q

  def initialize company, params_q
    @company = company
    @params_q = params_q
    @count = {}
    @dashboard = {}
  end

  def prioritize_jobs
    @company.jobs.includes(:applies).job_company(@company).sort_max_salary_and_target
  end

  def prioritize_applies
    @company.applies.includes(:job).sort_apply
  end

  def total_apply_statuses
    @company.apply_statuses.current.size
  end

  def params_q
    @company.apply_statuses.current.search @params_q
  end

  def count_apply
    params_q.result(distinct: true).group_by(&:step).each do |f|
      @count[I18n.t("employers.dashboards.list_statistic.#{f.first.name}").upcase] = f.second.size
    end
    @count
  end

  def dashboard_apply
    params_q.result(distinct: true).group_by(&:step).each do |f|
      @dashboard[f.first.name] = f.second.size
    end
    @dashboard
  end
end
