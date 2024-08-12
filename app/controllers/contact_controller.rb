class ContactController < ApplicationController
  def new
    # Pas besoin de modèle ici
  end

  def create
    # Récupération des paramètres directement depuis le formulaire
    name = params[:name]
    email = params[:email]
    subject = params[:subject]
    message = params[:message]

    # Envoi de l'e-mail via le mailer
    ContactMailer.contact_email(name, email, subject, message).deliver_now

    flash[:contact_notice] = "Votre message a bien été envoyé."
    redirect_to contact_path
  end
end
