Rails.application.routes.draw do
  root 'pages#home'

  get 'search', to: 'pages#search'

  resources :professionals, only: [:index, :show]
  resources :emergency_numbers, only: [:index, :show]

  get 'contact', to: 'pages#contact'
  post 'contact', to: 'pages#contact'
end
