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

    if opening_hours[current_day_in_french].present?
      opening_hours[current_day_in_french].each do |range|
        start_time, end_time = range.split("-").map(&:strip)
        if Time.zone.parse(current_time) >= Time.zone.parse(start_time) &&
           Time.zone.parse(current_time) <= Time.zone.parse(end_time)
          return true
        end
      end
    end

    false
  end

  private

  # Méthode de validation personnalisée
  def speciality_inclusion
    return if SPECIALITIES.any? { |s| speciality.include?(s) }

    errors.add(:speciality, "doit contenir une des spécialités de base : #{SPECIALITIES.join(', ')}")
  end
end
