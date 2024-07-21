class EmergencyNumbersController < ApplicationController
  def index
    @emergency_numbers = EmergencyNumber.all
    @local_emergency_numbers = params[:query_city].present? ? EmergencyNumber.where(is_local: true, region: params[:query_city]) : []
    render :emergency_numbers
  end

  def show
  end
end
