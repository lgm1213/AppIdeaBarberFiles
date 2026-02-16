class ShopInvitationsController < ApplicationController
  before_action :require_user, only: [ :create ]
  before_action :require_shop_owner, only: [ :create ]

  def create
    @shop = current_user.shops.find(params[:shop_id])
    @invitation = @shop.shop_invitations.build(invitation_params)
    @invitation.invited_by = current_user

    if @invitation.save
      ShopInvitationMailer.invitation_email(@invitation).deliver_later
      redirect_to shop_path(@shop, tab: "staff"), notice: "Invitation sent successfully."
    else
      redirect_to shop_path(@shop, tab: "staff"), alert: "Failed to send invitation: #{@invitation.errors.full_messages.join(', ')}"
    end
  end

  def accept
    @invitation = ShopInvitation.find_by!(token: params[:token])

    if @invitation.expired?
      render plain: "This invitation has expired.", status: :gone
      return
    end

    if @invitation.status != "pending"
      render plain: "This invitation has already been #{@invitation.status}.", status: :unprocessable_entity
      return
    end

    if @invitation.role_type == "staff"
      if current_user
        @invitation.accept!(current_user)
        redirect_to root_path, notice: "You have accepted the staff invitation to #{@invitation.shop.name}."
      else
        session[:pending_invitation_token] = @invitation.token
        redirect_to signup_path, alert: "Please create an account to accept this staff invitation."
      end
    else
      if current_user && current_user.barber?
        @invitation.accept!(current_user)
        redirect_to root_path, notice: "You have accepted the invitation to #{@invitation.shop.name}."
      else
        redirect_to login_path, alert: "Please log in as a barber to accept this invitation."
      end
    end
  end

  def decline
    @invitation = ShopInvitation.find_by!(token: params[:token])

    if @invitation.status == "pending"
      @invitation.decline!
    end

    redirect_to root_path, notice: "Invitation declined."
  end

  private

  def invitation_params
    params.require(:shop_invitation).permit(:email_address, :message, :role_type)
  end
end
