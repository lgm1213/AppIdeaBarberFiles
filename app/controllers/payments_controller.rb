class PaymentsController < ApplicationController
  before_action :require_user
  before_action :set_appointment
  before_action :authorize_payment

  def new
  end

  def create
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @appointment.amount,
      description: "Payment for Appointment ##{@appointment.id}",
      currency: "usd"
    )

    @appointment.update(stripe_charge_id: charge.id)
    redirect_to appointments_path, notice: "Payment was successful."
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_appointment_payment_path(@appointment)
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end

  def authorize_payment
    unless @appointment.client_id == current_user.id || @appointment.barber_id == current_user.id
      redirect_to appointments_path, alert: "You are not authorized to access this payment."
    end
  end
end
