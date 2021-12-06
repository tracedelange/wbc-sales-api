Rails.application.routes.draw do
  resources :reports, only: [:index, :create]
  resources :distributers, only: [:index, :show]
  resources :products

  resources :distributer_products, only: [:show, :update]

  post '/login', to: 'sessions#create'
  post '/signup', to: 'users#create'
  get '/me', to: 'users#me'
  get '/users/search', to: 'users#search'

  # get '/order-graph/:product_id', to: 'charts#search'

  get '/graphs/:product_id', to: 'graphs#search'


  get "/accounts/by_order_count", to: "accounts#most_orders"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
