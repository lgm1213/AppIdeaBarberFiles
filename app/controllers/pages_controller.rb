class PagesController < ApplicationController
  def home
    if current_user
      redirect_to appointments_path
    end
  end
end
