class MarketingMailer < ApplicationMailer
  def special_offer(client, message)
    @client = client
    @message = message
    mail(to: client.email_address, subject: "A Special Offer for You")
  end
end
