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
    @open_now = params[:open_now] == 'true'

    @professionals = Professional.all

    # Filtrer par spécialité
    if @search_query_pro.present?
      @professionals = @professionals.search_by_speciality(@search_query_pro)
    end

    # Filtrer par ville et coordonnée
    if @search_query_city.present?
      @search_query_coordinates = Geocoder.coordinates(@search_query_city)
      if @search_query_coordinates.present?
        @professionals = @professionals.near(@search_query_coordinates, 100)
        @professionals = @professionals.search_by_city(@search_query_city)
      end
    end

    # Appliquer l'offset et l'ordre avant de récupérer les résultats
    skip = params[:skip].to_i
    @professionals = @professionals.order(:id).offset(skip)

    # Filtrer par "Open Now" en Ruby après avoir récupéré les résultats si @open_now est vrai
    if @open_now
      @professionals = @professionals.to_a.select(&:open_now?) # Convertir en tableau pour filtrer
    end

    # Ne pas utiliser where sur un tableau
    @markers = @professionals.reject { |p| p.latitude.nil? || p.longitude.nil? }.map do |professional|
      {
        lat: professional.latitude,
        lng: professional.longitude,
        info_window_html: render_to_string(partial: "partials/info_window", locals: { professional: professional }),
        marker_html: render_to_string(partial: "partials/marker", locals: { professional: professional }),
        professional_id: professional.id
      }
    end

    respond_to do |format|
      format.html
      format.js { render partial: 'professionals/professional_card', collection: @professionals, as: :professional }
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
