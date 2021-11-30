Rails.application.routes.draw do
  resources :reports, only: [:index, :create]
  resources :distributers, only: [:index, :show]
  resources :products

  post '/login', to: 'sessions#create'
  post '/signup', to: 'users#create'
  get '/me', to: 'users#me'
  get '/users/search', to: 'users#search'


  get "/accounts/by_order_count", to: "accounts#most_orders"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
