# app/helpers/professionals_helper.rb

module ProfessionalsHelper
  def distance_between(search_coordinates, professional)
    # Convertir les coordonnées du professionnel en un objet Geocoder::Result
    professional_coordinates = [professional.latitude, professional.longitude]

    # Calculer la distance en utilisant Geocoder.distance_between
    distance = Geocoder::Calculations.distance_between(search_coordinates, professional_coordinates)

    # Convertir la distance en fonction de l'unité optimisée
    if distance < 1
      # Distance en mètres, arrondie à la 50aine de mètres près
      rounded_distance = (distance * 1000).round(-1)  # arrondi à la dizaine la plus proche
      "#{rounded_distance} m"
    else
      # Distance en kilomètres, arrondie à un chiffre après la virgule
      "#{distance.round(1)} km"
    end
  end
end
