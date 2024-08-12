class EmergencyNumber < ApplicationRecord
  validates :name, :phone_number, :description, presence: true
  validates :phone_number, presence: true
  validates :region, presence: true, if: :is_local

  def local?
    is_local
  end
end
