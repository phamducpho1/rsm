class Employers::SendEmailsController < ApplicationController
  before_action :load_company, :load_apply, :load_apply_status

  def create
    SendEmailUserJob.perform_later params[:title], @apply, params[:template_content], @company, @apply_status
    send_mail_interviewer if @apply.interview_scheduled?
    @messages = t "success"
    respond_to :js
  end

  private

  def load_apply
    @apply = Apply.find_by id: params[:apply_id]
    return if @apply.present?
    flash[:success] = t "not_find_item"
    redirect_to root_path
  end

  def load_apply_status
    @apply_status = ApplyStatus.find_by id: params[:apply_status_id]
    return if @apply.present?
    flash[:success] = t "not_find_item"
    redirect_to root_path
  end

  def send_mail_interviewer
    @apply.inforappointments.each do |inforappointment|
      SendEmailJob.perform_later inforappointment, @company
    end
  end
end
