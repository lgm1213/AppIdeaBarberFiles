class AppointmentsController < ApplicationController
  before_action :require_user

  def index
    if current_user.barber?
      @appointments = Appointment.where(barber_id: current_user.id)
    elsif current_user.staff?
      shop = current_user.staff_shop
      if shop
        barber_ids = shop.staff_barbers.pluck(:id)
        @appointments = Appointment.where(barber_id: barber_ids)
      else
        @appointments = Appointment.none
      end
    else
      @appointments = Appointment.where(client_id: current_user.id)
    end
  end

  def new
    @appointment = Appointment.new
  end

  def create
    appointment_params_with_cents = appointment_params
    if appointment_params_with_cents[:amount]
      appointment_params_with_cents[:amount] = (appointment_params_with_cents[:amount].to_f * 100).to_i
    end

    if current_user.client?
      @appointment = Appointment.new(appointment_params_with_cents.merge(client_id: current_user.id))
    else
      @appointment = Appointment.new(appointment_params_with_cents)
    end

    if @appointment.save
      redirect_to appointments_path, notice: "Appointment created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:client_id, :barber_id, :start_time, :end_time, :status, :amount)
  end
end
