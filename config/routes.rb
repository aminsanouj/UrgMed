Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Routes Devise pour la connexion seulement avec Admin
  devise_for :admins, only: [:sessions]

  root 'pages#home'

  resources :professionals, only: [:index, :show]
  resources :emergency_numbers, only: [:index, :show]

  get 'search', to: 'pages#search'
  get 'contact', to: 'pages#contact'
  post 'contact', to: 'contact#create'
  get 'professionals/:id/details', to: 'pages#professional_details', as: :professional_details, defaults: { format: :html }
end
