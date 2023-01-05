Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "garages#index"

  get '/garages', to: 'garages#index'
  get '/garages/:id', to: 'garages#show'
  get '/garages/:id/profile', to: 'garages#profile'
  put '/garages/:id/update', to: 'garages#update'

  post '/auth', to: 'sessions#create'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
end
