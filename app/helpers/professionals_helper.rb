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
    sorted_hours = order.map do |day|
      opening_hours.find { |h| h.keys.include?(day) && h[day].any?(&:present?) } || { day => [] }
    end
    sorted_hours.reject { |day_hash| day_hash.values.flatten.empty? }
                .map { |day_hash| [day_hash.keys.first, format_opening_hours(day_hash.values.first)] }.to_h
  end

  def format_opening_hours(hours)
    hours.reject(&:empty?).map do |h|
      ranges = h.split(',').map do |range|
        start_time, end_time = range.split('-')
        formatted_range = "#{start_time.sub(':', 'h')}-#{end_time.sub(':', 'h')}"
        formatted_range
      end

      # Merge ranges that start and end with "00h00"
      merged_ranges = []
      i = 0
      while i < ranges.length
        if ranges[i].start_with?("00h00-") && ranges[i].end_with?("-00h00")
          merged_ranges << ranges[i][6..-7]
        else
          merged_ranges << ranges[i]
        end
        i += 1
      end

      merged_ranges.join(', ')
    end.join(', ')
  end

  def format_24h_opening_hours(range)
    range == "00h00-24h00" ? "24h/24h" : range
  end

  def fetch_professionals(professionals, speciality)
    professionals.select { |p| p.speciality.include?(speciality) }
  end
end
