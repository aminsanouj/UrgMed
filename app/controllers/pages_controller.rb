class PagesController < ApplicationController
  include ProfessionalsHelper
  protect_from_forgery except: :search
  respond_to? :html, :js

  def home
    # Code pour récupérer les données nécessaires à afficher sur la page d'accueil
  end

  def search
    @search_query_city = params[:query_city].presence
    @open_now = params[:open_now] == 'true'
    @tags = params[:tags]&.split(',') || []
    @professionals = Professional.all

    if @search_query_city.present?
      @search_query_coordinates = Geocoder.coordinates(@search_query_city)
      if @search_query_coordinates.present?
        @professionals = @professionals.near(@search_query_coordinates, 100)
      end
    else
      @search_query_city = ""
      @search_query_coordinates = []
    end

    if @tags.any?
      @professionals = @professionals.search_by_speciality(@tags)
    end

    skip = params[:skip].to_i
    @professionals = @professionals.order(:id).offset(skip)

    if @open_now
      @professionals = @professionals.to_a.select(&:open_now?)
    end

    @marker_query_city = {
      lat: @search_query_coordinates[0],
      lng: @search_query_coordinates[1],
      marker_city_html: render_to_string(partial: "partials/marker_city", locals: { city: @search_query_city })
    }

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
      format.js {
        render json: {
          partials: render_to_string(partial: 'professionals/professional_card', collection: @professionals, as: :professional),
          markers: @markers,
          marker_query_city: @marker_query_city
        }
      }
    end
  end

  def professional_details
    @professional = Professional.find(params[:id])
    @search_query_coordinates = Geocoder.coordinates(params[:query_city])
    render partial: 'professionals/professional_details', formats: [:html]
  end

  def show
    @professional = Professional.find(params[:id])
  end

  def contact
    if request.post?
      flash[:notice] = "Votre message a bien été envoyé !"
      redirect_to contact_path
    end
  end
end
