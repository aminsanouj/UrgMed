class EmergencyNumbersController < ApplicationController
  def index

    Rails.logger.info("Received parameters - Region: #{params[:region]}, Department: #{params[:department]}")
    # Numéros nationaux
    @national_numbers = EmergencyNumber.where(is_local: false)

    # Numéros locaux
    # Numéros régionaux
    regional_numbers = if params[:region].present?
                         EmergencyNumber.where(is_local: true, region: params[:region], department: [nil, ''])
                       else
                         []
                       end

    Rails.logger.info("Regional Numbers #{regional_numbers}")
    # Numéros départementaux
    departmental_numbers = if params[:department].present?
                             EmergencyNumber.where(is_local: true, department: params[:department])
                           else
                             []
                           end
    Rails.logger.info("Departemtal Numbers #{departmental_numbers}")
    # Combiner les numéros régionaux et départementaux
    @local_emergency_numbers = regional_numbers + departmental_numbers

    render :emergency_numbers
  end

  def show
    @emergency_number = EmergencyNumber.find(params[:id])
  end
end
