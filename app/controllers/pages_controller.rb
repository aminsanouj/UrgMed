class PagesController < ApplicationController
  include ProfessionalsHelper
  protect_from_forgery except: :search
  respond_to? :html, :js

  def home
    # Code pour récupérer les données nécessaires à afficher sur la page d'accueil
  end

  def search
    @search_query_pro = params[:query_pro].presence
    @search_query_city = params[:query_city].presence
    @search_query_coordinates = Geocoder.coordinates(@search_query_city)

    @professionals = Professional.all

    if @search_query_pro.present?
      @professionals = @professionals.search_by_speciality(@search_query_pro)
    end

    if @search_query_city.present?
      if @search_query_coordinates.present?
        @professionals = @professionals.near(@search_query_coordinates, 100)
        @professionals = @professionals.search_by_city(@search_query_city)
      end
    end

    # Récupérer le paramètre 'skip' de la requête AJAX
    skip = params[:skip].to_i

    # Récupérer les résultats en prenant en compte le paramètre 'skip'
    @professionals = @professionals.order(:id).offset(skip)

    @markers = @professionals.where.not(latitude: nil, longitude: nil).map do |professional|
      {
        lat: professional.latitude,
        lng: professional.longitude,
        info_window_html: render_to_string(partial: "partials/info_window", locals: { professional: professional }),
        marker_html: render_to_string(partial: "partials/marker", locals: { professional: professional })
      }
    end

    respond_to do |format|
      format.html # rendre la page HTML complète
      format.js { render partial: 'professionals/professional_card', collection: @professionals, as: :professional } # rendre la requête partielle
    end
  end

  def professional_details
    @professional = Professional.find(params[:id])
    @search_query_coordinates = Geocoder.coordinates(params[:query_city])
    render partial: 'professionals/professional_details', formats: [:html]
  end

  def show
  end

  def contact
    if request.post?
      # Code pour gérer les soumissions de formulaire de contact
      # Par exemple, envoyer un email ou enregistrer les informations dans la base de données
      flash[:notice] = "Votre message a bien été envoyé !"
      redirect_to contact_path
    end
  end
end
