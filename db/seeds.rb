=begin
# db/seeds.rb

# Effacer les enregistrements existants
Admin.destroy_all
EmergencyNumber.destroy_all
Professional.destroy_all

Admin.create!(
  email: 'admin@urgmed.com',
  password: 'admin@urgmed.com',
  password_confirmation: 'admin@urgmed.com'
)

EmergencyNumber.create!([
  # National emergency numbers
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
    name: "Pharmacie de Garde",
    phone_number: "3237",
    description: "Numéro pour trouver une pharmacie de garde ouverte près de chez vous.",
    call_price: "0,35€/min"
  },
  {
    name: "SOS Femmes violences conjugales",
    phone_number: "3919",
    description: "Numéro d'urgence pour les femmes victimes de violences conjugales."
  },
  {
    name: "Urgences sociales",
    phone_number: "115",
    description: "Numéro d'urgence pour les situations d'urgence sociale."
  },
  {
    name: "Numéro d'urgence pour les personnes sourdes et malentendantes",
    phone_number: "114",
    description: "Numéro d'urgence pour les personnes sourdes et malentendantes."
  },
  # Regional emergency numbers
  {
    name: "Centre Antipoison de Toulouse",
    phone_number: "05 61 77 74 47",
    description: "Numéro d'urgence pour obtenir des conseils en cas d'intoxication.",
    is_local: true,
    region: "Occitanie"
  },
  {
    name: "Permanence des soins dentaires Occitanie Est",
    phone_number: "15",
    description: "Numéro d'urgence pour les soins dentaires en Occitanie Est.",
    is_local: true,
    region: "Occitanie"
  },
  {
    name: "Permanence des soins dentaires Occitanie Ouest",
    phone_number: "3966",
    description: "Numéro d'urgence pour les soins dentaires en Occitanie Ouest.",
    is_local: true,
    region: "Occitanie"
  },
  {
    name: "Allo j'aide un proche",
    phone_number: "0806 806 830",
    description: "Numéro d'urgence pour aider un proche.",
    is_local: true,
    region: "Occitanie"
  },
])

# Désactiver le callback avant de créer les enregistrements
Professional.skip_callback(:save, :before, :process_opening_hours, if: :format_valid?)

Professional.create!([
  # Médecins
  {
    first_name: "Pierre",
    last_name: "Lafont",
    speciality: "Médecin Généraliste",
    street: "75 Rue d'Alsace-Lorraine",
    postal_code: "31000",
    city: "Toulouse",
    latitude: 43.607315,
    longitude: 1.445632,
    phone_number: "05 61 04 04 04",
    website: "http://dr-pierre-lafont.fr",
    opening_hours: [
      { "Lundi" => ["08:00-18:00"] },
      { "Mardi" => ["08:00-18:00"] },
      { "Mercredi" => ["08:00-18:00"] },
      { "Jeudi" => ["08:00-18:00"] },
      { "Vendredi" => ["08:00-18:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Marie",
    last_name: "Durand",
    speciality: "Médecin - Gynécologue",
    street: "3 Rue Cambronne",
    postal_code: "75015",
    city: "Paris",
    latitude: 48.847334,
    longitude: 2.301944,
    phone_number: "01 45 06 06 06",
    website: "http://dr-marie-durand.fr",
    opening_hours: [
      { "Lundi" => ["09:00-18:00"] },
      { "Mardi" => ["09:00-18:00"] },
      { "Mercredi" => ["09:00-18:00"] },
      { "Jeudi" => ["09:00-18:00"] },
      { "Vendredi" => [] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Luc",
    last_name: "Martin",
    speciality: "Médecin - Cardiologue",
    street: "18 Rue de la République",
    postal_code: "69002",
    city: "Lyon",
    latitude: 45.764043,
    longitude: 4.835659,
    phone_number: "04 78 07 07 07",
    website: "http://dr-luc-martin.fr",
    opening_hours: [
      { "Lundi" => [] },
      { "Mardi" => ["10:00-17:00"] },
      { "Mercredi" => ["10:00-17:00"] },
      { "Jeudi" => ["10:00-17:00"] },
      { "Vendredi" => ["10:00-17:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Sophie",
    last_name: "Bernard",
    speciality: "Médecin - Dermatologue",
    street: "15 Rue de la loge",
    postal_code: "13002",
    city: "Marseille",
    latitude: 43.296482,
    longitude: 5.369780,
    phone_number: "04 91 08 08 08",
    website: "http://dr-sophie-bernard.fr",
    opening_hours: [
      { "Lundi" => ["08:30-16:30"] },
      { "Mardi" => ["08:30-16:30"] },
      { "Mercredi" => ["08:30-16:30"] },
      { "Jeudi" => ["08:30-16:30"] },
      { "Vendredi" => ["08:30-16:30"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Olivier",
    last_name: "Gauthier",
    speciality: "Médecin - ORL",
    street: "6 Place Rohan",
    postal_code: "33000",
    city: "Bordeaux",
    latitude: 44.837789,
    longitude: -0.579180,
    phone_number: "05 56 09 09 09",
    website: "http://dr-olivier-gauthier.fr",
    opening_hours: [
      { "Lundi" => ["09:00-18:00"] },
      { "Mardi" => ["09:00-18:00"] },
      { "Mercredi" => ["09:00-18:00"] },
      { "Jeudi" => ["09:00-18:00"] },
      { "Vendredi" => [] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  # Dentistes
  {
    first_name: "Anne",
    last_name: "Girard",
    speciality: "Dentiste",
    street: "14 Rue de Belfort",
    postal_code: "31000",
    city: "Toulouse",
    latitude: 43.608941,
    longitude: 1.451256,
    phone_number: "05 61 05 05 05",
    website: "http://dr-anne-girard.fr",
    opening_hours: [
      { "Lundi" => ["09:00-17:00"] },
      { "Mardi" => ["09:00-17:00"] },
      { "Mercredi" => ["09:00-17:00"] },
      { "Jeudi" => ["09:00-17:00"] },
      { "Vendredi" => ["09:00-17:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Marc",
    last_name: "Dubois",
    speciality: "Dentiste",
    street: "16 Rue Gabriel Péri",
    postal_code: "31000",
    city: "Toulouse",
    latitude: 43.605555,
    longitude: 1.452222,
    phone_number: "05 61 09 09 09",
    website: "http://dr-marc-dubois.fr",
    opening_hours: [
      { "Lundi" => ["08:30-16:30"] },
      { "Mardi" => ["08:30-16:30"] },
      { "Mercredi" => ["08:30-16:30"] },
      { "Jeudi" => ["08:30-16:30"] },
      { "Vendredi" => ["08:30-16:30"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Sophie",
    last_name: "Martin",
    speciality: "Dentiste",
    street: "Place du 11 Novembre 1918",
    postal_code: "75116",
    city: "Paris",
    latitude: 48.863056,
    longitude: 2.287222,
    phone_number: "01 45 00 00 00",
    website: "http://dr-sophie-martin.fr",
    opening_hours: [
      { "Lundi" => ["09:00-18:00"] },
      { "Mardi" => ["09:00-18:00"] },
      { "Mercredi" => ["09:00-18:00"] },
      { "Jeudi" => ["09:00-18:00"] },
      { "Vendredi" => ["09:00-18:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Olivier",
    last_name: "Rousseau",
    speciality: "Dentiste",
    street: "51 Cours de l'Intendance",
    postal_code: "33000",
    city: "Bordeaux",
    latitude: 44.841944,
    longitude: -0.578333,
    phone_number: "05 56 00 00 00",
    website: "http://dr-olivier-rousseau.fr",
    opening_hours: [
      { "Lundi" => ["10:00-19:00"] },
      { "Mardi" => ["10:00-19:00"] },
      { "Mercredi" => ["10:00-19:00"] },
      { "Jeudi" => ["10:00-19:00"] },
      { "Vendredi" => ["10:00-19:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Laura",
    last_name: "Lambert",
    speciality: "Dentiste",
    street: "18 Rue de la République",
    postal_code: "69002",
    city: "Lyon",
    latitude: 45.764044,
    longitude: 4.835667,
    phone_number: "04 72 00 00 00",
    website: "http://dr-laura-lambert.fr",
    opening_hours: [
      { "Lundi" => ["08:00-17:00"] },
      { "Mardi" => ["08:00-17:00"] },
      { "Mercredi" => ["08:00-17:00"] },
      { "Jeudi" => ["08:00-17:00"] },
      { "Vendredi" => ["08:00-17:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "François",
    last_name: "Berger",
    speciality: "Dentiste",
    street: "15 Rue de la loge",
    postal_code: "13002",
    city: "Marseille",
    latitude: 43.296482,
    longitude: 5.369780,
    phone_number: "04 91 00 00 00",
    website: "http://dr-francois-berger.fr",
    opening_hours: [
      { "Lundi" => ["09:00-18:00"] },
      { "Mardi" => ["09:00-18:00"] },
      { "Mercredi" => ["09:00-18:00"] },
      { "Jeudi" => ["09:00-18:00"] },
      { "Vendredi" => ["09:00-18:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  # Pharmacies
  {
    first_name: "Pharmacie",
    last_name: "de la Garonne",
    speciality: "Pharmacie",
    street: "10 Rue Louis Deffes",
    postal_code: "31000",
    city: "Toulouse",
    latitude: 43.602389,
    longitude: 1.448711,
    phone_number: "05 61 06 06 06",
    website: "http://pharmacie-garonne.fr",
    opening_hours: [
      { "Lundi" => ["08:30-19:30"] },
      { "Mardi" => ["08:30-19:30"] },
      { "Mercredi" => ["08:30-19:30"] },
      { "Jeudi" => ["08:30-19:30"] },
      { "Vendredi" => ["08:30-19:30"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Pharmacie",
    last_name: "du Capitole",
    speciality: "Pharmacie",
    street: "3 Rue Lafayette",
    postal_code: "31000",
    city: "Toulouse",
    latitude: 43.604667,
    longitude: 1.444167,
    phone_number: "05 61 10 10 10",
    website: "http://pharmacie-capitole.fr",
    opening_hours: [
      { "Lundi" => ["09:00-19:00"] },
      { "Mardi" => ["09:00-19:00"] },
      { "Mercredi" => ["09:00-19:00"] },
      { "Jeudi" => ["09:00-19:00"] },
      { "Vendredi" => ["09:00-19:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Pharmacie",
    last_name: "des Halles",
    speciality: "Pharmacie",
    street: "8 Place de l' Hotel de Ville",
    postal_code: "75004",
    city: "Paris",
    latitude: 48.856614,
    longitude: 2.352222,
    phone_number: "01 42 33 44 55",
    website: "http://pharmacie-halles.fr",
    opening_hours: [
      { "Lundi" => ["08:30-20:00"] },
      { "Mardi" => ["08:30-20:00"] },
      { "Mercredi" => ["08:30-20:00"] },
      { "Jeudi" => ["08:30-20:00"] },
      { "Vendredi" => ["08:30-20:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Pharmacie",
    last_name: "du Vieux Port",
    speciality: "Pharmacie",
    street: "15 Rue de la loge",
    postal_code: "13002",
    city: "Marseille",
    latitude: 43.296482,
    longitude: 5.369780,
    phone_number: "04 91 91 91 91",
    website: "http://pharmacie-vieuxport.fr",
    opening_hours: [
      { "Lundi" => ["09:00-19:30"] },
      { "Mardi" => ["09:00-19:30"] },
      { "Mercredi" => ["09:00-19:30"] },
      { "Jeudi" => ["09:00-19:30"] },
      { "Vendredi" => ["09:00-19:30"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Pharmacie",
    last_name: "des Jacobins",
    speciality: "Pharmacie",
    street: "2 Rue Gasparin",
    postal_code: "69002",
    city: "Lyon",
    latitude: 45.760108,
    longitude: 4.833333,
    phone_number: "04 72 77 88 99",
    website: "http://pharmacie-jacobins.fr",
    opening_hours: [
      { "Lundi" => ["08:00-20:00"] },
      { "Mardi" => ["08:00-20:00"] },
      { "Mercredi" => ["08:00-20:00"] },
      { "Jeudi" => ["08:00-20:00"] },
      { "Vendredi" => ["08:00-20:00"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  {
    first_name: "Pharmacie",
    last_name: "de la Comédie",
    speciality: "Pharmacie",
    street: "10 Place de la Comédie",
    postal_code: "34000",
    city: "Montpellier",
    latitude: 43.6090787,
    longitude: 3.8800735,
    phone_number: "04 67 67 88 99",
    website: "http://pharmacie-comedie.fr",
    opening_hours: [
      { "Lundi" => ["08:30-19:30"] },
      { "Mardi" => ["08:30-19:30"] },
      { "Mercredi" => ["08:30-19:30"] },
      { "Jeudi" => ["08:30-19:30"] },
      { "Vendredi" => ["08:30-19:30"] },
      { "Samedi" => [] },
      { "Dimanche" => [] }
    ],
  },
  # Services d'urgence
  {
    first_name: "Hôpital",
    last_name: "Purpan",
    speciality: "Urgences",
    street: "10 Rue Vincent Scotto",
    postal_code: "31300",
    city: "Toulouse",
    latitude: 43.597500,
    longitude: 1.418056,
    phone_number: "05 61 07 07 07",
    website: "http://chu-toulouse.fr/purpan",
    opening_hours: [
      { "Lundi" => ["00:00-24:00"] },
      { "Mardi" => ["00:00-24:00"] },
      { "Mercredi" => ["00:00-24:00"] },
      { "Jeudi" => ["00:00-24:00"] },
      { "Vendredi" => ["00:00-24:00"] },
      { "Samedi" => ["00:00-24:00"] },
      { "Dimanche" => ["00:00-24:00"] }
    ],
  },
  {
    first_name: "Hôpital",
    last_name: "de la Pitié-Salpêtrière",
    speciality: "Urgences",
    street: "53 Rue David Bowie",
    postal_code: "75013",
    city: "Paris",
    latitude: 48.840317,
    longitude: 2.364485,
    phone_number: "01 42 16 00 00",
    website: "https://www.aphp.fr/hopitaux/pitie-salpetriere",
    opening_hours: [
      { "Lundi" => ["00:00-24:00"] },
      { "Mardi" => ["00:00-24:00"] },
      { "Mercredi" => ["00:00-24:00"] },
      { "Jeudi" => ["00:00-24:00"] },
      { "Vendredi" => ["00:00-24:00"] },
      { "Samedi" => ["00:00-24:00"] },
      { "Dimanche" => ["00:00-24:00"] }
    ],
  },
  {
    first_name: "Hôpital",
    last_name: "Nord",
    speciality: "Urgences",
    street: "196 Avenue corot",
    postal_code: "13014",
    city: "Marseille",
    latitude: 43.326444,
    longitude: 5.400556,
    phone_number: "04 91 96 11 11",
    website: "https://www.ap-hm.fr/fr/etablissements/hopital-nord",
    opening_hours: [
      { "Lundi" => ["00:00-24:00"] },
      { "Mardi" => ["00:00-24:00"] },
      { "Mercredi" => ["00:00-24:00"] },
      { "Jeudi" => ["00:00-24:00"] },
      { "Vendredi" => ["00:00-24:00"] },
      { "Samedi" => ["00:00-24:00"] },
      { "Dimanche" => ["00:00-24:00"] }
    ],
  },
  {
    first_name: "CHU",
    last_name: "de Nantes",
    speciality: "Urgences",
    street: "29 Rue de Strasbourg",
    postal_code: "44000",
    city: "Nantes",
    latitude: 47.218611,
    longitude: -1.553611,
    phone_number: "02 40 08 33 33",
    website: "https://www.chu-nantes.fr",
    opening_hours: [
      { "Lundi" => ["00:00-24:00"] },
      { "Mardi" => ["00:00-24:00"] },
      { "Mercredi" => ["00:00-24:00"] },
      { "Jeudi" => ["00:00-24:00"] },
      { "Vendredi" => ["00:00-24:00"] },
      { "Samedi" => ["00:00-24:00"] },
      { "Dimanche" => ["00:00-24:00"] }
    ],
  },
  {
    first_name: "Hôpital",
    last_name: "Édouard Herriot",
    speciality: "Urgences",
    street: "132 Rue Pierre Corneille",
    postal_code: "69003",
    city: "Lyon",
    latitude: 45.759167,
    longitude: 4.844444,
    phone_number: "04 72 11 61 11",
    website: "https://www.chu-lyon.fr/fr/les-hopitaux/hopital-edouard-herriot-heh",
    opening_hours: [
      { "Lundi" => ["00:00-24:00"] },
      { "Mardi" => ["00:00-24:00"] },
      { "Mercredi" => ["00:00-24:00"] },
      { "Jeudi" => ["00:00-24:00"] },
      { "Vendredi" => ["00:00-24:00"] },
      { "Samedi" => ["00:00-24:00"] },
      { "Dimanche" => ["00:00-24:00"] }
    ],
  },
  {
    first_name: "CHU",
    last_name: "de Lille",
    speciality: "Urgences",
    street: "83 Rue du Molinel",
    postal_code: "59800",
    city: "Lille",
    latitude: 50.633889,
    longitude: 3.066944,
    phone_number: "03 20 44 44 59",
    website: "https://www.chu-lille.fr",
    opening_hours: [
      { "Lundi" => ["00:00-24:00"] },
      { "Mardi" => ["00:00-24:00"] },
      { "Mercredi" => ["00:00-24:00"] },
      { "Jeudi" => ["00:00-24:00"] },
      { "Vendredi" => ["00:00-24:00"] },
      { "Samedi" => ["00:00-24:00"] },
      { "Dimanche" => ["00:00-24:00"] }
    ],
  }
])

puts "Seeds created successfully! 🌱"
=end
