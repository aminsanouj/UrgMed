class EmergencyNumbersController < ApplicationController
  def index
    @emergency_numbers = EmergencyNumber.all
  end

  def show
  end
end
