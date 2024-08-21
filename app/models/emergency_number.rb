class EmergencyNumber < ApplicationRecord
  REGIONS_AND_DEPARTMENTS = {
    'Auvergne-Rhône-Alpes' => [
      '01 - Ain', '03 - Allier', '07 - Ardèche', '15 - Cantal', '26 - Drôme', '38 - Isère', '42 - Loire',
      '43 - Haute-Loire', '63 - Puy-de-Dôme', '69 - Rhône', '73 - Savoie', '74 - Haute-Savoie'
    ],
    'Bourgogne-Franche-Comté' => [
      '21 - Côte-d\'Or', '25 - Doubs', '39 - Jura', '58 - Nièvre', '70 - Haute-Saône', '71 - Saône-et-Loire',
      '89 - Yonne', '90 - Territoire de Belfort'
    ],
    'Bretagne' => [
      '22 - Côtes-d\'Armor', '29 - Finistère', '35 - Ille-et-Vilaine', '56 - Morbihan'
    ],
    'Centre-Val de Loire' => [
      '18 - Cher', '28 - Eure-et-Loir', '36 - Indre', '37 - Indre-et-Loire', '41 - Loir-et-Cher', '45 - Loiret'
    ],
    'Corse' => [
      '2A - Corse-du-Sud', '2B - Haute-Corse'
    ],
    'Grand Est' => [
      '08 - Ardennes', '10 - Aube', '51 - Marne', '52 - Haute-Marne', '54 - Meurthe-et-Moselle', '55 - Meuse',
      '57 - Moselle', '67 - Bas-Rhin', '68 - Haut-Rhin', '88 - Vosges'
    ],
    'Hauts-de-France' => [
      '02 - Aisne', '59 - Nord', '60 - Oise', '62 - Pas-de-Calais', '80 - Somme'
    ],
    'Île-de-France' => [
      '75 - Paris', '77 - Seine-et-Marne', '78 - Yvelines', '91 - Essonne', '92 - Hauts-de-Seine',
      '93 - Seine-Saint-Denis', '94 - Val-de-Marne', '95 - Val-d\'Oise'
    ],
    'Normandie' => [
      '14 - Calvados', '27 - Eure', '50 - Manche', '61 - Orne', '76 - Seine-Maritime'
    ],
    'Nouvelle-Aquitaine' => [
      '16 - Charente', '17 - Charente-Maritime', '19 - Corrèze', '23 - Creuse', '24 - Dordogne', '33 - Gironde',
      '40 - Landes', '47 - Lot-et-Garonne', '64 - Pyrénées-Atlantiques', '79 - Deux-Sèvres', '86 - Vienne', '87 - Haute-Vienne'
    ],
    'Occitanie' => [
      '09 - Ariège', '11 - Aude', '12 - Aveyron', '30 - Gard', '31 - Haute-Garonne', '32 - Gers', '34 - Hérault',
      '46 - Lot', '48 - Lozère', '65 - Hautes-Pyrénées', '66 - Pyrénées-Orientales', '81 - Tarn', '82 - Tarn-et-Garonne'
    ],
    'Pays de la Loire' => [
      '44 - Loire-Atlantique', '49 - Maine-et-Loire', '53 - Mayenne', '72 - Sarthe', '85 - Vendée'
    ],
    'Provence-Alpes-Côte d\'Azur' => [
      '04 - Alpes-de-Haute-Provence', '05 - Hautes-Alpes', '06 - Alpes-Maritimes', '13 - Bouches-du-Rhône', '83 - Var',
      '84 - Vaucluse'
    ]
  }.freeze

  REGIONS = REGIONS_AND_DEPARTMENTS.keys.freeze
  DEPARTMENTS = REGIONS_AND_DEPARTMENTS.values.flatten.freeze
  DEPARTMENTS_BY_REGION = REGIONS_AND_DEPARTMENTS.freeze

  before_validation :set_default_is_local
  before_save :extract_department_name

  validates :name, :phone_number, :description, presence: true
  validates :phone_number, presence: true
  validates :region, presence: { message: "doit être renseignée si le numéro est local." }, if: :is_local
  validates :region, absence: { message: "ne doit pas être renseignée si le numéro n'est pas local." }, unless: :is_local
  validates :department, absence: { message: "ne doit pas être renseigné si le numéro n'est pas local." }, unless: :is_local
  validate :department_belongs_to_region, if: :is_local

  def local?
    is_local
  end

  def formatted_department
    department_code = DEPARTMENTS.find { |d| d.split(' - ').last == department }
    department_code || department
  end

  private

  def set_default_is_local
    self.is_local = false if is_local.nil?
  end

  def extract_department_name
    if department.present? && department.include?(' - ')
      self.department = department.split(' - ').last
    end
  end

  def department_belongs_to_region
    return if region.blank? || department.blank?

    valid_departments = DEPARTMENTS_BY_REGION[region]
    unless valid_departments&.include?(department)
      errors.add(:department, "doit appartenir à la région #{region}.")
    end
  end
end
