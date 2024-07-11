Geocoder.configure(
  # Choisissez le service de géocodage
  lookup: :google,

  # Utilisez une clé API sécurisée depuis les variables d'environnement
  api_key: ENV['GOOGLE_MAPS_API_KEY'],

  # Temps d'attente en secondes pour les requêtes de géocodage
  timeout: 5,

  # Unité de distance (:km pour les kilomètres, :mi pour les miles)
  units: :km,

  # En-têtes HTTP personnalisés pour certains services de géocodage
  http_headers: {
    "User-Agent" => "MyApp",
    "Referer" => "http://localhost:3000/"
  },

  # Activez le débogage pour enregistrer les requêtes et les réponses
  logger: Rails.logger,

  # Gérez les erreurs pour toujours les remonter
  always_raise: :all,
  # Geocoding options
  # timeout: 3,                 # geocoding service timeout (secs)     # name of geocoding service (symbol)
  # ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
  # language: :en,              # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  # api_key: nil,               # API key for geocoding service
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #del)
  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear

  # Cache configuration
  # cache_options: {
  #   expiration: 2.days,
  #   prefix: 'geocoder:'
  # }
)
