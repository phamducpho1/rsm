class Employers::AppliesController < Employers::EmployersController
  before_action :load_members, only: [:edit, :update]
  before_action :load_templates, only: :update
  before_action :create_appointment, only: :edit, if: :is_scheduled?
  before_action :load_appointments, only: [:edit, :update], if: :is_scheduled?


  def edit
    @is_interview_scheduled = is_status?(params[:status], Apply.statuses.keys[6])
    respond_to do |format|
      format.js
    end
  end

  def show
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    respond_to do |format|
      if @apply.update_attributes apply_params
        @apply.save_activity current_user, :update, @apply.status
        Notification.create_notification t("content_notification_update_apply",
          job: @apply.job_name), :user, @apply, current_user.id
        handling_after_update_success
        format.js{@messages = t "employers.applies.update.success"}
      else
        @is_interview_scheduled = @apply.interview_scheduled?
        format.js{@errors = t "employers.applies.update.fail"}
      end
    end
  end

  private

  def handling_after_update_success
    handling_with_interview_scheduled if @apply.interview_scheduled?
    reset_appointment
  end

  def handling_with_interview_scheduled
    create_inforappointments if params[:states].present?
  end

  def reset_appointment
    Appointment.transaction do
      if Apply.statuses.keys.take(3).include? @apply.status
        @apply.appointments.destroy_all
      else @apply.test_passed? || @apply.test_not_selected?
        @apply.appointments.interview_scheduled.destroy_all
      end
    end
  end

  def apply_params
    params.require(:apply).permit :status,
      appointments_attributes: %i(user_id address company_id start_time end_time type_appointment apply_id)
  end

  def load_appointments
    @appointments = @company.appointments.includes(:apply).get_greater_equal_by(Date.current).
      group_by{|appointment| appointment.apply_information[:name]}
  end

  def create_inforappointments
    @members = params[:states]
    appointment = @apply.appointments.find_by type_appointment: Apply.statuses.keys[6]
    return unless appointment
    inforappointments = @members.map do |member_id|
      next if member_id.blank?
      info_appointment = Inforappointment.new(user_id: member_id, appointment_id: appointment.id)
      info_appointment.create_activation_digest
      info_appointment
    end
    Inforappointment.import inforappointments
  end

  def is_scheduled?
    status = params[:status] || apply_params[:status]
    return false if status.blank?
    is_status?(status, Apply.statuses.keys[3]) ||
      is_status?(status, Apply.statuses.keys[6])
  end

  def is_status? new_status, status
    new_status == status
  end

  def create_appointment
    @apply.appointments.new company_id: @company.id, type_appointment: params[:status]
  end
end
