class EmergencyNumbersController < ApplicationController
  def index
    @emergency_numbers = EmergencyNumber.all
    render :emergency_numbers
  end

  def show
  end
end
