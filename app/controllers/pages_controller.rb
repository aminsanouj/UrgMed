# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def home
    # Code pour récupérer les données nécessaires à afficher sur la page d'accueil
  end

  def search
    @search_query_pro = params[:query_pro]
    @search_query_city = params[:query_city]

    @professionals = Professional.all

    if @search_query_pro.present?
      @professionals = @professionals.search_by_speciality(@search_query_pro)
    end

    if @search_query_city.present?
      @professionals = @professionals.search_by_city(@search_query_city)
    end

    @markers = @professionals.geocoded.map do |professional|
      {
        lat: professional.latitude,
        lng: professional.longitude,
        info_window_html: render_to_string(partial: "partials/info_window", locals: {professional: professional}),
        marker_html: render_to_string(partial: "partials/marker", locals: {professional: professional})
      }
    end
  end

  def show
    @professional = Professional.find(params[:id])
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
