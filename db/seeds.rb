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
  }
])

# Professionals in Toulouse
Professional.create([
  {
    first_name: "Jean",
    last_name: "Dupont",
    speciality: "Médecin Généraliste",
    address: "10 Rue de la Santé, 31000 Toulouse",
    latitude: 43.604652,
    longitude: 1.444209,
    phone_number: "05 61 00 00 00",
    website: "http://dr-jean-dupont.fr",
    hours: "Lundi à Vendredi: 8h-18h",
    on_duty: true
  },
  {
    first_name: "Marie",
    last_name: "Durand",
    speciality: "Dentiste",
    address: "20 Avenue des Dents, 31000 Toulouse",
    latitude: 43.610769,
    longitude: 1.438499,
    phone_number: "05 61 01 01 01",
    website: "http://dr-marie-durand.fr",
    hours: "Lundi à Jeudi: 9h-17h",
    on_duty: false
  },
  {
    first_name: "Luc",
    last_name: "Martin",
    speciality: "Cardiologue",
    address: "5 Place du Coeur, 31000 Toulouse",
    latitude: 43.603722,
    longitude: 1.441524,
    phone_number: "05 61 02 02 02",
    website: "http://dr-luc-martin.fr",
    hours: "Mardi à Vendredi: 10h-18h",
    on_duty: false
  },
  {
    first_name: "Sophie",
    last_name: "Bernard",
    speciality: "Pédiatre",
    address: "15 Boulevard des Enfants, 31000 Toulouse",
    latitude: 43.600555,
    longitude: 1.442078,
    phone_number: "05 61 03 03 03",
    website: "http://dr-sophie-bernard.fr",
    hours: "Lundi à Vendredi: 9h-19h",
    on_duty: true
  }
])

puts "Seeds created successfully! 🌱"
