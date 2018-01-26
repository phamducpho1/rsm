class  Employers::ApplyStatusesController < Employers::EmployersController
  before_action :load_apply, only: [:new, :create]
  before_action :load_status_step_scheduled, only: :create
  before_action :get_step_by_company, :load_current_step,
    :load_status_step_interview_scheduled, only: [:create, :new]
  before_action :load_templates, only: [:create, :new]
  before_action :build_apply_statuses, only: :new
  before_action :new_appointment, only: :new
  before_action :load_members, :load_appointments, only: [:create, :new]

  def new
    respond_to :js
  end

  def create
    ApplyStatus.transaction do
      set_not_current
      respond_to do |format|
        if @apply_status.save
          create_next_step
          create_inforappointments if @interview_scheduled_ids.include?(@apply_status.status_step_id)
          @apply_status.save_activity :create, current_user
          Notification.create_notification :user, @apply,
            current_user, @apply.job.company_id, @apply.user_id if @apply.user_id
          after_action_create
          format.js{@messages = t "employers.applies.update.success"}
        else
          raise ActiveRecord::Rollback
          format.js{@errors = t "employers.applies.update.fail"}
        end
      end
    end
  end

  private

  def apply_status_params
    params.require(:apply_status).permit :apply_id, :status_step_id, :is_current,
      appointment_attributes: %i(user_id address company_id start_time end_time type_appointment)
  end

  def create_inforappointments
    @members = params[:states]
    return if @members.blank?
    appointment = @apply_status.appointment
    return unless appointment
    inforappointments = @members.map do |member_id|
      next if member_id.blank?
      info_appointment = Inforappointment.new(user_id: member_id,
        appointment_id: appointment.id)
      info_appointment.create_activation_digest
      info_appointment
    end
    Inforappointment.import inforappointments
  end

  def after_action_create
    load_current_step
    load_next_step
    load_prev_step
    load_statuses_by_current_step
    build_apply_statuses
    build_next_and_prev_apply_statuses
    load_apply_statuses
  end

  def create_next_step
    return if @apply_status.status_step.is_status?(Settings.not_selected) || @apply_status.status_step.is_status?(Settings.pending)
    load_next_step
    if @next_step.present? &&
      !@company_stattus_step_ids.include?(@apply_status.status_step_id)
      set_not_current
      @apply.apply_statuses.create status_step_id: @next_step.status_steps.first.id,
        is_current: :current
    end
  end

  def set_not_current
    @apply.apply_statuses.current.update_all is_current: :not_current
  end

  def load_apply
    apply_id = params[:apply_id] || apply_status_params[:apply_id]
    @apply = Apply.find_by id: apply_id
    return if @apply
    redirect_to root_url
  end

  def build_apply_statuses
    status_step_id = if params[:status].present?
      params[:status]
    else
      @current_apply_status.status_step_id
    end
    @apply_status = @apply.apply_statuses.build is_current: :current,
      status_step_id: status_step_id
  end

  def new_appointment
    type_appointment = @interview_scheduled_ids.include?(params[:status].to_i) ? :interview_scheduled : :test_scheduled
    @apply_status.build_appointment type_appointment: type_appointment, company_id: @company.id
  end

  def load_appointments
    @appointments = @company.appointments.includes(:apply_status, :apply)
      .get_greater_equal_by(Date.current).group_by{|appointment| appointment.apply.information[:name]}
  end
end
