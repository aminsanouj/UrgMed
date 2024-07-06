# app/models/professional.rb
class Professional < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_speciality,
                  against: :speciality,
                  using: {
                    tsearch: { prefix: true, any_word: true }
                  },
                  ignoring: :accents

  pg_search_scope :search_by_city,
                  against: :address,
                  using: {
                    tsearch: { prefix: true, any_word: true }
                  },
                  ignoring: :accents
end
