class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Check for pending staff invitation
    invitation = nil
    if session[:pending_invitation_token].present?
      invitation = ShopInvitation.find_by(token: session[:pending_invitation_token], status: "pending", role_type: "staff")
    end

    if invitation
      @user.role = "Staff"
    end

    if @user.save
      session[:user_id] = @user.id

      if invitation
        invitation.accept!(@user)
        session.delete(:pending_invitation_token)
        redirect_to root_path, notice: "Account created! You've been added as staff to #{invitation.shop.name}."
      else
        redirect_to root_path, notice: "Successfully created account"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    permitted = params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation, :role)
    # STI expects class names (capitalized), form sends lowercase
    permitted[:role] = permitted[:role].capitalize if permitted[:role].present?
    permitted
  end
end
