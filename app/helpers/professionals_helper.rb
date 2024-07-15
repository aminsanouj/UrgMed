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

  def sorted_opening_hours(opening_hours)
    order = %w(Lundi Mardi Mercredi Jeudi Vendredi Samedi Dimanche)
    sorted_hours = Hash[order.zip(order.map { |day| opening_hours[day] })]
    sorted_hours.map { |day, hours| [day, format_opening_hours(hours)] }.to_h
  end

  def format_opening_hours(hours)
    hours.map { |h| "#{h.split('-')[0]} à #{h.split('-')[1]}" }.join(', ')
  end

end
