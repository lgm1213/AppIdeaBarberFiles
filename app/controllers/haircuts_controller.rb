class HaircutsController < ApplicationController
  before_action :require_user

  def index
    if current_user.barber?
      @haircuts = Haircut.where(barber_id: current_user.id)
    else
      @haircuts = Haircut.where(client_id: current_user.id)
    end
  end

  def new
    @haircut = Haircut.new
    if current_user.barber?
      @haircut.barber_id = current_user.id
    end
  end

  def create
    if current_user.barber?
      @haircut = Haircut.new(haircut_params.merge(barber_id: current_user.id))
    else
      @haircut = Haircut.new(haircut_params.merge(client_id: current_user.id))
    end

    if @haircut.save
      redirect_to haircuts_path, notice: "Haircut created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def haircut_params
    params.require(:haircut).permit(:client_id, :barber_id, :details, :image)
  end
end
