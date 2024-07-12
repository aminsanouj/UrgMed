module ProfessionalsHelper
  def distance_between(search_coordinates, professional)
    professional_coordinates = professional.is_a?(Array) ? professional : [professional.latitude, professional.longitude]

    distance = Geocoder::Calculations.distance_between(search_coordinates, professional_coordinates)

    if distance < 1
      rounded_distance = (distance * 1000).round(-1)  # arrondi à la dizaine la plus proche
      "#{rounded_distance} m"
    else
      "#{distance.round(1)} km"
    end
  end
end
