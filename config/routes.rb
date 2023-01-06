Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "garages#index"

  get '/garages', to: 'garages#index'
  get '/garages/:id', to: 'garages#show'
  get '/users/profile', to: 'users#edit'
  put '/users/update', to: 'users#update'

  post '/auth', to: 'sessions#create'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
