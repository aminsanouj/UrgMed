class Professional < ApplicationRecord
  include PgSearch::Model

  SPECIALITIES = ['Médecin', 'Pharmacie', 'Dentiste', 'Urgences'].freeze

  # Validations
  validates :first_name, :last_name, :speciality, :phone_number, :street, :postal_code, :city, :opening_hours, presence: true
  validates :phone_number, format: { with: /\A0[1-9](?:[\s.-]?\d{2}){4}\z/, message: "doit être un numéro de téléphone français valide" }, if: -> { phone_number.present? }
  validates :postal_code, format: { with: /\A\d{5}\z/, message: "doit être un code postal français valide" }, if: -> { postal_code.present? }
  validate :speciality_inclusion
  validate :validate_opening_hours_format, if: :opening_hours_present?

  # Callbacks
  before_save :process_opening_hours, if: :format_valid?
  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_street? || :will_save_change_to_postal_code? || :will_save_change_to_city?

  # Scopes
  pg_search_scope :search_by_speciality,
                  against: :speciality,
                  using: {
                    tsearch: { prefix: true, any_word: true }
                  },
                  ignoring: :accents

  # Methods
  def full_address
    [street, postal_code, city].join(', ')
  end

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

    opening_hours.any? do |day_hash|
      day_hash.any? do |day, ranges|
        next unless day == current_day_in_french

        ranges.any? do |range|
          range.split(",").any? do |sub_range|
            next if sub_range.strip.empty?

            start_time, end_time = sub_range.split("-").map(&:strip)
            Time.zone.parse(start_time) <= Time.zone.parse(current_time) &&
              Time.zone.parse(current_time) <= Time.zone.parse(end_time)
          end
        end
      end
    end
  end

  def process_opening_hours
    if opening_hours.is_a?(Array)
      self.opening_hours = opening_hours.map do |day_hash|
        day, hours = day_hash.first
        formatted_hours = hours.map { |range| range.gsub(/(\d{2}):(\d{2})/, '\1h\2') }
        "#{day} : #{formatted_hours.join(', ')}"
      end.join("\n")
    elsif opening_hours.is_a?(String) && errors[:opening_hours].empty?
      self.opening_hours = opening_hours.split("\n").map do |line|
        day, hours = line.split(':').map(&:strip)
        if hours.empty?
          { day => [] }
        else
          formatted_hours = hours.split(',').map { |range| range.strip.gsub(/(\d{2})h(\d{2})/, '\1:\2') }
          { day => formatted_hours }
        end
      end
    end
  end

  private

  def speciality_inclusion
    return if speciality.blank? || SPECIALITIES.any? { |s| speciality.include?(s) }

    errors.add(:speciality, "doit contenir une des spécialités : #{SPECIALITIES.join(', ')}")
  end

  def validate_opening_hours_format
    return unless opening_hours.is_a?(String)

    valid_format = /\A(?:Lundi|Mardi|Mercredi|Jeudi|Vendredi|Samedi|Dimanche)\s*:\s*(?:(?:\d{2}h\d{2}-\d{2}h\d{2})(?:\s*,\s*\d{2}h\d{2}-\d{2}h\d{2})*)?\z/

    unless opening_hours.split("\n").all? { |line| line.strip.gsub(/\s+/, ' ').match?(valid_format) }
      errors.add(:opening_hours, "doit être au format Ex : 'Lundi : 08h00-17h00, Mardi 08h00-17h00 etc.'")
    end
  end

  def opening_hours_present?
    opening_hours.present?
  end

  def format_valid?
    errors[:opening_hours].empty?
  end
end
