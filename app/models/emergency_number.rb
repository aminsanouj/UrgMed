class EmergencyNumber < ApplicationRecord
  before_validation :set_default_is_local
  
  validates :name, :phone_number, :description, presence: true
  validates :phone_number, presence: true
  validates :region, presence: { message: "ne peut pas être vide si le numéro est local. Veuillez sélectionner une région." }, if: :is_local

  def local?
    is_local
  end

  private

  def set_default_is_local
    self.is_local = false if is_local.nil?
  end
end
