class Employers::DashboardsController < ApplicationController
  layout "employers/employer"

  before_action :authenticate_user!
  before_action :load_company
  before_action :check_permissions_employer
  before_action :current_ability
  before_action :load_notification

  def index
    @apply = @company.applies
    @prioritize_jobs = Job.includes(:applies).job_company(@company).sort_max_salary_and_target
    @prioritize_applies = @company.applies.includes(:job).sort_apply
    @hash = SelectApply.caclulate_applies @apply
    respond_to do |format|
      format.html
      format.js{render json: @apply.group(:status).group_by_week("applies.created_at").count.chart_json}
    end
  end

  private

  def check_permissions_employer
    return if current_user.is_employer_of? @company.id
    flash[:danger] = t "company_mailer.fail"
    redirect_to root_url
  end
end
