Rails.application.routes.draw do
  root 'pages#home'

  resources :professionals, only: [:index, :show]
  resources :emergency_numbers, only: [:index, :show]

  get 'search', to: 'pages#search'
  get 'contact', to: 'pages#contact'
  post 'contact', to: 'contact#create'
end
