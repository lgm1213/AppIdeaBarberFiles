class MarketingCampaignsController < ApplicationController
  before_action :require_user
  before_action :require_barber

  def new
  end

  def create
    clients = current_user.appointments.map(&:client).uniq
    clients.each do |client|
      MarketingMailer.special_offer(client, marketing_campaign_params[:message]).deliver_later
    end
    redirect_to root_path, notice: "Marketing campaign sent successfully."
  end

  private

  def require_barber
    redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user.barber?
  end

  def marketing_campaign_params
    params.require(:marketing_campaign).permit(:message)
  end
end
