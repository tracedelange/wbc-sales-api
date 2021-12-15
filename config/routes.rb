Rails.application.routes.draw do
  resources :reports, only: [:index, :create]
  resources :distributers, only: [:index, :show]
  resources :products

  resources :accounts, only: [:show, :update]

  resources :distributer_products, only: [:show, :update]

  post '/login', to: 'sessions#create'
  post '/signup', to: 'users#create'
  get '/me', to: 'users#me'
  get '/users/search', to: 'users#search'

  # get '/order-graph/:product_id', to: 'charts#search'

  get '/graphs/:product_id', to: 'graphs#search'


  get "/account_query/name", to: "account_queries#query_by_name"
  get "/account_query/alpha_page", to: "account_queries#alphabetical_pagination"
  get "/account_query/order_page", to: "account_queries#order_count_pagination"
  get "/account_query/by_order_count", to: "account_queries#most_orders"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
