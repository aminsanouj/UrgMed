module PagesHelper
  def svg_for_speciality(speciality)
    case
    when speciality.include?('Médecin')
      'medecin.svg'
    when speciality == 'Urgences'
      'urgences.svg'
    when speciality == 'Pharmacie'
      'pharmacie.svg'
    when speciality == 'Dentiste'
      'dentiste.svg'
    else
      'default.svg' # Assurez-vous d'avoir un SVG par défaut
    end
  end
end
