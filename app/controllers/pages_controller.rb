# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  include ProfessionalsHelper
  protect_from_forgery except: :search

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

    # Retirer la pagination pour récupérer tous les résultats
    @all_professionals = @professionals

    # Réappliquer la pagination pour les résultats affichés dans container-results
    @professionals = @professionals.paginate(page: params[:page], per_page: 3)

    @markers = @all_professionals.where.not(latitude: nil, longitude: nil).map do |professional|
      {
        lat: professional.latitude,
        lng: professional.longitude,
        info_window_html: render_to_string(partial: "partials/info_window", locals: { professional: professional }),
        marker_html: render_to_string(partial: "partials/marker", locals: { professional: professional })
      }
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
