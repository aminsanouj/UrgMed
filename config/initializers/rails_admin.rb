RailsAdmin.config do |config|
  config.asset_source = :sprockets

  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.current_user_method(&:current_admin)

  # Configuration des modèles
  config.model 'Professional' do
    create do
      field :first_name
      field :last_name
      field :speciality
      field :phone_number
      field :website
      field :street
      field :postal_code
      field :city
      field :opening_hours, :text do
        default_value "Lundi : 08h00-17h00\nMardi : 08h00-17h00\nMercredi : 08h00-17h00\nJeudi : 08h00-17h00\nVendredi : 08h00-17h00\nSamedi : 08h00-17h00\nDimanche : 08h00-17h00"
      end
    end

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
      field :phone_number
      field :website
      field :street
      field :postal_code
      field :city
      field :opening_hours, :text do
        help "Lundi : 08h00-17h00\nMardi : 08h00-17h00 etc."
        formatted_value do
          bindings[:object].process_opening_hours
        end
      end
    end
  end

  config.model 'EmergencyNumber' do
    create do
      field :name
      field :phone_number
      field :description
      field :is_local, :enum do
        enum do
          [['Oui', true], ['Non', false]]
        end
      end
      field :region, :enum do
        enum do
          EmergencyNumber::REGIONS
        end
      end
      field :department, :enum do
        enum do
          EmergencyNumber::DEPARTMENTS
        end
      end
      field :call_price do
        help 'Ex : 0,35€/min'
      end
    end

    list do
      field :name
      field :phone_number
      field :region
      field :is_local
      field :department
      field :call_price do
        formatted_value do
          value.present? ? '✓' : ''
        end
      end
    end

    edit do
      field :name
      field :phone_number
      field :description
      field :is_local, :enum do
        enum do
          [['Oui', true], ['Non', false]]
        end
      end
      field :region, :enum do
        enum do
          EmergencyNumber::REGIONS
        end
      end
      field :department, :enum do
        enum do
          EmergencyNumber::DEPARTMENTS
        end
        formatted_value do
          bindings[:object].formatted_department
        end
      end
      field :call_price do
        help 'Ex : 0,35€/min'
      end
    end
  end
end
