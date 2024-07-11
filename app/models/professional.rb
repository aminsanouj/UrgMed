class Professional < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_speciality,
                  against: :speciality,
                  using: {
                    tsearch: { prefix: true, any_word: true }
                  },
                  ignoring: :accents

  pg_search_scope :search_by_city,
                  against: [:city, :postal_code, :street],
                  using: {
                    tsearch: { prefix: true, any_word: true }
                  },
                  ignoring: :accents

  def full_address
    [street, postal_code, city].join(', ')
  end

  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_street? || :will_save_change_to_postal_code? || :will_save_change_to_city?
end
