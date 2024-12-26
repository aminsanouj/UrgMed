class ContactController < ApplicationController
  def create
    # Récupération des paramètres directement depuis le formulaire
    name = params[:name]
    email = params[:email]
    subject = params[:subject]
    message = params[:message]

    # Vérification des champs requis
    if name.blank? || email.blank? || subject.blank? || message.blank?
      flash[:contact_notice] = "Tous les champs doivent être remplis."
      flash[:contact_notice_type] = "error"
      flash[:contact_form] = { name: name, email: email, subject: subject, message: message }
      redirect_to contact_path and return
    end

    # Envoi de l'e-mail via le mailer
    ContactMailer.contact_email(name, email, subject, message).deliver_now
    flash[:contact_notice] = "Votre message a bien été envoyé."
    flash[:contact_notice_type] = "success"
    redirect_to contact_path
  end
end
