# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def home
    # Code pour récupérer les données nécessaires à afficher sur la page d'accueil
  end

  def search
    @search_query = params[:query]
    @professionals = Professional.where("speciality LIKE ?", "%#{@search_query}%")
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