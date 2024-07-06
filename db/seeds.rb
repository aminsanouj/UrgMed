# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Emergency numbers for Toulouse
EmergencyNumber.create([
  {
    name: "Police",
    phone_number: "17",
    description: "Numéro d'urgence pour contacter la police en cas de besoin."
  },
  {
    name: "Pompiers",
    phone_number: "18",
    description: "Numéro d'urgence pour contacter les pompiers en cas d'incendie ou de secours à personnes."
  },
  {
    name: "SAMU",
    phone_number: "15",
    description: "Numéro d'urgence pour contacter le SAMU en cas d'urgence médicale."
  },
  {
    name: "Urgence Europe",
    phone_number: "112",
    description: "Numéro d'urgence européen, disponible dans tous les pays de l'Union Européenne."
  },
  {
    name: "SAMU Social",
    phone_number: "115",
    description: "Numéro d'urgence pour les personnes sans abri ou en grande précarité."
  },
  {
    name: "Enfance Maltraitée",
    phone_number: "119",
    description: "Numéro d'urgence pour signaler des cas de maltraitance sur des enfants."
  },
  {
    name: "Centre Antipoison",
    phone_number: "01 40 05 48 48",
    description: "Numéro d'urgence pour obtenir des conseils en cas d'intoxication."
  },
  {
    name: "Urgence Médicale de Paris",
    phone_number: "01 53 94 94 94",
    description: "Numéro d'urgence pour contacter les urgences médicales à Paris."
  },
  {
    name: "Pharmacie de Garde",
    phone_number: "3237",
    description: "Numéro pour trouver une pharmacie de garde ouverte près de chez vous."
  }
])


Professional.create([
  # Médecins
  {
    first_name: "Pierre",
    last_name: "Lafont",
    speciality: "Médecin Généraliste",
    address: "3 Rue des Soins, 31000 Toulouse",
    latitude: 43.607315,
    longitude: 1.445632,
    phone_number: "05 61 04 04 04",
    website: "http://dr-pierre-lafont.fr",
    hours: "Lundi à Vendredi: 8h-18h",
    on_duty: false
  },
  {
    first_name: "Jean",
    last_name: "Duparc",
    speciality: "Pédiatre",
    address: "15 Rue des Enfants, 31000 Toulouse",
    latitude: 43.601234,
    longitude: 1.449876,
    phone_number: "05 61 08 08 08",
    website: "http://dr-jean-duparc.fr",
    hours: "Lundi à Vendredi: 9h-17h",
    on_duty: false
  },
  {
    first_name: "Marie",
    last_name: "Durand",
    speciality: "Gynécologue",
    address: "7 Rue de la Santé, 75015 Paris",
    latitude: 48.847334,
    longitude: 2.301944,
    phone_number: "01 45 06 06 06",
    website: "http://dr-marie-durand.fr",
    hours: "Lundi à Jeudi: 9h-18h",
    on_duty: false
  },
  {
    first_name: "Luc",
    last_name: "Martin",
    speciality: "Cardiologue",
    address: "21 Avenue du Coeur, 69003 Lyon",
    latitude: 45.764043,
    longitude: 4.835659,
    phone_number: "04 78 07 07 07",
    website: "http://dr-luc-martin.fr",
    hours: "Mardi à Vendredi: 10h-17h",
    on_duty: false
  },
  {
    first_name: "Sophie",
    last_name: "Bernard",
    speciality: "Dermatologue",
    address: "10 Boulevard de la Peau, 13001 Marseille",
    latitude: 43.296482,
    longitude: 5.369780,
    phone_number: "04 91 08 08 08",
    website: "http://dr-sophie-bernard.fr",
    hours: "Lundi à Vendredi: 8h30-16h30",
    on_duty: false
  },
  {
    first_name: "Olivier",
    last_name: "Gauthier",
    speciality: "ORL",
    address: "6 Rue de l'Ouïe, 33000 Bordeaux",
    latitude: 44.837789,
    longitude: -0.579180,
    phone_number: "05 56 09 09 09",
    website: "http://dr-olivier-gauthier.fr",
    hours: "Lundi à Jeudi: 9h-18h",
    on_duty: false
  },
  # Dentistes
  {
    first_name: "Anne",
    last_name: "Girard",
    speciality: "Dentiste",
    address: "7 Avenue de la Dentisterie, 31000 Toulouse",
    latitude: 43.608941,
    longitude: 1.451256,
    phone_number: "05 61 05 05 05",
    website: "http://dr-anne-girard.fr",
    hours: "Lundi à Vendredi: 9h-17h",
    on_duty: false
  },
  {
    first_name: "Marc",
    last_name: "Dubois",
    speciality: "Dentiste",
    address: "21 Rue du Sourire, 31000 Toulouse",
    latitude: 43.605555,
    longitude: 1.452222,
    phone_number: "05 61 09 09 09",
    website: "http://dr-marc-dubois.fr",
    hours: "Lundi à Vendredi: 8h30-16h30",
    on_duty: false
  },
  {
    first_name: "Sophie",
    last_name: "Martin",
    speciality: "Dentiste",
    address: "10 Boulevard Victor Hugo, 75016 Paris",
    latitude: 48.863056,
    longitude: 2.287222,
    phone_number: "01 45 00 00 00",
    website: "http://dr-sophie-martin.fr",
    hours: "Lundi à Jeudi: 9h-18h",
    on_duty: false
  },
  {
    first_name: "Olivier",
    last_name: "Rousseau",
    speciality: "Dentiste",
    address: "3 Place de la Bourse, 33000 Bordeaux",
    latitude: 44.841944,
    longitude: -0.578333,
    phone_number: "05 56 00 00 00",
    website: "http://dr-olivier-rousseau.fr",
    hours: "Lundi à Vendredi: 10h-19h",
    on_duty: false
  },
  {
    first_name: "Laura",
    last_name: "Lambert",
    speciality: "Dentiste",
    address: "5 Rue de la République, 69001 Lyon",
    latitude: 45.764044,
    longitude: 4.835667,
    phone_number: "04 72 00 00 00",
    website: "http://dr-laura-lambert.fr",
    hours: "Lundi à Jeudi: 8h-17h",
    on_duty: false
  },
  {
    first_name: "François",
    last_name: "Berger",
    speciality: "Dentiste",
    address: "8 Avenue du Général Leclerc, 13008 Marseille",
    latitude: 43.296482,
    longitude: 5.369780,
    phone_number: "04 91 00 00 00",
    website: "http://dr-francois-berger.fr",
    hours: "Lundi à Vendredi: 9h-18h",
    on_duty: false
  },

  # Pharmacies
  {
    first_name: "Pharmacie",
    last_name: "de la Garonne",
    speciality: "Pharmacie",
    address: "12 Boulevard de la Garonne, 31000 Toulouse",
    latitude: 43.602389,
    longitude: 1.448711,
    phone_number: "05 61 06 06 06",
    website: "http://pharmacie-garonne.fr",
    hours: "Lundi à Samedi: 8h30-19h30",
    on_duty: false
  },
  {
    first_name: "Pharmacie",
    last_name: "du Capitole",
    speciality: "Pharmacie",
    address: "8 Place du Capitole, 31000 Toulouse",
    latitude: 43.604667,
    longitude: 1.444167,
    phone_number: "05 61 10 10 10",
    website: "http://pharmacie-capitole.fr",
    hours: "Lundi à Samedi: 9h-19h",
    on_duty: false
  },
  {
    first_name: "Pharmacie",
    last_name: "des Halles",
    speciality: "Pharmacie",
    address: "1 Rue des Halles, 75001 Paris",
    latitude: 48.856614,
    longitude: 2.352222,
    phone_number: "01 42 33 44 55",
    website: "http://pharmacie-halles.fr",
    hours: "Lundi à Samedi: 8h30-20h",
    on_duty: false
  },
  {
    first_name: "Pharmacie",
    last_name: "du Vieux Port",
    speciality: "Pharmacie",
    address: "3 Quai du Port, 13002 Marseille",
    latitude: 43.296482,
    longitude: 5.369780,
    phone_number: "04 91 91 91 91",
    website: "http://pharmacie-vieuxport.fr",
    hours: "Lundi à Samedi: 9h-19h30",
    on_duty: false
  },
  {
    first_name: "Pharmacie",
    last_name: "des Jacobins",
    speciality: "Pharmacie",
    address: "7 Place des Jacobins, 69002 Lyon",
    latitude: 45.760108,
    longitude: 4.833333,
    phone_number: "04 72 77 88 99",
    website: "http://pharmacie-jacobins.fr",
    hours: "Lundi à Samedi: 8h-20h",
    on_duty: false
  },
  {
    first_name: "Pharmacie",
    last_name: "de la Comédie",
    speciality: "Pharmacie",
    address: "10 Place de la Comédie, 34000 Montpellier",
    latitude: 43.610769,
    longitude: 3.876716,
    phone_number: "04 67 67 88 99",
    website: "http://pharmacie-comedie.fr",
    hours: "Lundi à Samedi: 8h30-19h30",
    on_duty: false
  },

  # Services d'urgence
  {
    first_name: "Hôpital",
    last_name: "Purpan",
    speciality: "Urgences",
    address: "3 Place du Professeur Laguesse, 31000 Toulouse",
    latitude: 43.597500,
    longitude: 1.418056,
    phone_number: "05 61 07 07 07",
    website: "http://chu-toulouse.fr/purpan",
    hours: "Ouvert 24h/24 et 7j/7",
    on_duty: true
  },
  {
    first_name: "Hôpital",
    last_name: "de la Pitié-Salpêtrière",
    speciality: "Urgences",
    address: "47-83 Boulevard de l'Hôpital, 75013 Paris",
    latitude: 48.840317,
    longitude: 2.364485,
    phone_number: "01 42 16 00 00",
    website: "https://www.aphp.fr/hopitaux/pitie-salpetriere",
    hours: "Ouvert 24h/24 et 7j/7",
    on_duty: true
  },
  {
    first_name: "Hôpital",
    last_name: "Nord",
    speciality: "Urgences",
    address: "4 Chemin des Bourrely, 13015 Marseille",
    latitude: 43.326444,
    longitude: 5.400556,
    phone_number: "04 91 96 11 11",
    website: "https://www.ap-hm.fr/fr/etablissements/hopital-nord",
    hours: "Ouvert 24h/24 et 7j/7",
    on_duty: true
  },
  {
    first_name: "CHU",
    last_name: "de Nantes",
    speciality: "Urgences",
    address: "5 Allée de l'Île Gloriette, 44093 Nantes",
    latitude: 47.218611,
    longitude: -1.553611,
    phone_number: "02 40 08 33 33",
    website: "https://www.chu-nantes.fr",
    hours: "Ouvert 24h/24 et 7j/7",
    on_duty: true
  },
  {
    first_name: "Hôpital",
    last_name: "Édouard Herriot",
    speciality: "Urgences",
    address: "5 Place d'Arsonval, 69003 Lyon",
    latitude: 45.759167,
    longitude: 4.844444,
    phone_number: "04 72 11 61 11",
    website: "https://www.chu-lyon.fr/fr/les-hopitaux/hopital-edouard-herriot-heh",
    hours: "Ouvert 24h/24 et 7j/7",
    on_duty: true
  },
  {
    first_name: "CHU",
    last_name: "de Lille",
    speciality: "Urgences",
    address: "2 Avenue Oscar Lambret, 59000 Lille",
    latitude: 50.633889,
    longitude: 3.066944,
    phone_number: "03 20 44 44 59",
    website: "https://www.chu-lille.fr",
    hours: "Ouvert 24h/24 et 7j/7",
    on_duty: true
  }
])

puts "Seeds created successfully! 🌱"
