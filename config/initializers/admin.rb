# config/initializers/admin.rb

Rails.application.config.after_initialize do
  if Rails.env.development? && Admin.where(email: 'admin@urgmed.com').none?
    Admin.create!(
      email: 'admin@urgmed.com',
      password: 'admin@urgmed.com',
      password_confirmation: 'admin@urgmed.com'
    )
  end
end
