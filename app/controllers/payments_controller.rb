class PaymentsController < ApplicationController
  before_action :require_user
  before_action :set_appointment

  def new
  end

  def create
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @appointment.amount, # You'll need to add an amount to your appointments
      description: "Payment for Appointment ##{@appointment.id}",
      currency: 'usd'
    )

    @appointment.update(stripe_charge_id: charge.id)
    redirect_to appointments_path, notice: 'Payment was successful.'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_appointment_payment_path(@appointment)
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end
end
