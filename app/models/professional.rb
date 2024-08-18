class Professional < ApplicationRecord
  include PgSearch::Model

  SPECIALITIES = ['Médecin', 'Pharmacie', 'Dentiste', 'Urgences'].freeze

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :speciality, presence: true
  validate :speciality_inclusion
  validates :phone_number, presence: true, format: { with: /\A0[1-9](?:[\s.-]?\d{2}){4}\z/, message: "doit être un numéro de téléphone français valide" }
  validates :street, presence: true
  validates :postal_code, presence: true, format: { with: /\A\d{5}\z/, message: "doit être un code postal français valide" }
  validates :city, presence: true
  validates :opening_hours, presence: true
  validate :validate_opening_hours_format, if: :opening_hours_present?
  before_save :process_opening_hours, if: :format_valid?

  pg_search_scope :search_by_speciality,
                  against: :speciality,
                  using: {
                    tsearch: { prefix: true, any_word: true }
                  },
                  ignoring: :accents

  pg_search_scope :search_by_city,
                  against: [:city, :postal_code],
                  using: {
                    tsearch: { prefix: true, any_word: true }
                  },
                  ignoring: :accents

  def full_address
    [street, postal_code, city].join(', ')
  end

  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_street? || :will_save_change_to_postal_code? || :will_save_change_to_city?

  def open_now?
    french_day_names = {
      "Monday" => "Lundi",
      "Tuesday" => "Mardi",
      "Wednesday" => "Mercredi",
      "Thursday" => "Jeudi",
      "Friday" => "Vendredi",
      "Saturday" => "Samedi",
      "Sunday" => "Dimanche"
    }

    current_day_in_french = french_day_names[Time.zone.now.strftime("%A")]
    current_time = Time.zone.now.strftime("%H:%M")

    opening_hours.each do |day_hash|
      day_hash.each do |day, ranges|
        if day == current_day_in_french
          return false if ranges.empty?

          ranges.each do |range|
            range.split(",").each do |sub_range|
              next if sub_range.strip.empty?

              start_time, end_time = sub_range.split("-").map(&:strip)
              if Time.zone.parse(current_time) >= Time.zone.parse(start_time) &&
                  Time.zone.parse(current_time) <= Time.zone.parse(end_time)
                return true
              end
            end
          end
        end
      end
    end

    false
  end

  def process_opening_hours
    if self.opening_hours.is_a?(Array)
      self.opening_hours = self.opening_hours.map do |day_hash|
        day, hours = day_hash.first
        formatted_hours = hours.map do |range|
          range.gsub(/(\d{2}):(\d{2})/, '\1h\2')
        end
        "#{day} : #{formatted_hours.join(', ')}"
      end.join("\n")
    elsif self.opening_hours.is_a?(String)
      if !self.errors[:opening_hours].empty?
        self.opening_hours
      else
        converted_hours = []

        self.opening_hours.split("\n").each do |line|
          day, hours = line.split(':').map(&:strip)
          if hours.empty?
            converted_hours << { day => [] }
          else
            formatted_hours = hours.split(',').map do |range|
              range.strip.gsub(/(\d{2})h(\d{2})/, '\1:\2')
            end
            converted_hours << { day => formatted_hours }
          end
        end

        self.opening_hours = converted_hours
      end
    end
  end

  private

  def validate_opening_hours_format
    return unless self.opening_hours.is_a?(String)

    valid_format = /\A(?:Lundi|Mardi|Mercredi|Jeudi|Vendredi|Samedi|Dimanche)\s*:\s*(?:(?:\d{2}h\d{2}-\d{2}h\d{2})(?:\s*,\s*\d{2}h\d{2}-\d{2}h\d{2})*)?\z/

    self.opening_hours.split("\n").each do |line|
      cleaned_line = line.strip.gsub(/\s+/, ' ')
      unless cleaned_line.match?(valid_format)
        errors.add(:opening_hours, "doit être au format Ex : 'Lundi : 08h00-17h00, Mardi 08h00-17h00 etc.'")
        break
      end
    end
  end

  def speciality_inclusion
    return if SPECIALITIES.any? { |s| speciality.include?(s) }

    errors.add(:speciality, "doit contenir une des spécialités de base : #{SPECIALITIES.join(', ')}")
  end

  def opening_hours_present?
    self.opening_hours.present?
  end

  def format_valid?
    errors[:opening_hours].empty?
  end
end
