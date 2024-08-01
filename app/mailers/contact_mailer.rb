class ContactMailer < ApplicationMailer
  default from: 'no-reply@demomailtrap.com'

  def contact_email(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message

    mail(
      to: 'urgmed.contact@gmail.com',
      subject: "Formulaire de contact : #{subject}"
    )
  end
end
