RailsAdmin.config do |config|
  config.asset_source = :sprockets

  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.current_user_method(&:current_admin)

  # Configuration des modèles
  config.model 'Professional' do
    list do
      field :first_name
      field :last_name
      field :speciality
      field :city
      field :phone_number
    end

    edit do
      field :first_name
      field :last_name
      field :speciality
      field :latitude
      field :longitude
      field :phone_number
      field :website
      field :street
      field :postal_code
      field :city
      field :opening_hours, :json
    end
  end

  config.model 'EmergencyNumber' do
    list do
      field :name
      field :phone_number
      field :region
      field :is_local
    end

    edit do
      field :name
      field :phone_number
      field :description
      field :is_local
      field :region
      field :call_price
    end
  end
end
