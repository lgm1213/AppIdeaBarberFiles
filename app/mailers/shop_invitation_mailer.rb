class ShopInvitationMailer < ApplicationMailer
  def invitation_email(invitation)
    @invitation = invitation
    @shop = invitation.shop
    @accept_url = accept_invitation_url(token: invitation.token)
    @decline_url = decline_invitation_url(token: invitation.token)

    mail(to: invitation.email_address, subject: "You're invited to join #{@shop.name}")
  end
end
