RailsAdmin.config do |config|
  config.asset_source = :sprockets

  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.current_user_method(&:current_admin)

  # Ajouter l'action d'importation
  config.actions do
    all
    import # Ajoute cette ligne pour inclure l'action d'importation
  end

  # Configuration globale pour RailsAdminImport
  config.configure_with(:import) do |import_config|
    import_config.logging = true  # Activer la journalisation des importations
    import_config.line_item_limit = 1000  # Limite de lignes par importation
    import_config.update_if_exists = true  # Mettre à jour les enregistrements existants si une correspondance est trouvée
    import_config.rollback_on_error = true  # Annuler l'importation en cas d'erreur
  end

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

    # Configuration spécifique pour l'importation
    import do
      include_all_fields
      exclude_fields :id, :latitude, :longitude, :created_at, :updated_at
      mapping_key [:first_name, :last_name, :phone_number]
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

    # Configuration spécifique pour l'importation
    import do
      include_all_fields
      exclude_fields :id, :created_at, :updated_at
      mapping_key [:name, :phone_number, :region]
    end
  end
end
