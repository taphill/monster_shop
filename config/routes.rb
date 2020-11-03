Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :admin do
    root "dashboard#index"
    resources :users, only: [:index, :show]
    resources :orders, only: [:update]
    resources :merchants, only: [:index, :show, :update]
    namespace :merchants do
      scope '/:merchant_id/' do
        resources :items, except: [:show]
      end
    end
  end

  namespace :merchant do
    root 'dashboard#index'
    resources :items, except: [:show]
    get '/orders/:order_id', to: "orders#show"
  end

  resources :merchants
  get "/merchants/:merchant_id/items", to: 'items#index'

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show", as: 'item'

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id", to: "cart#change_quantity"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  namespace :profile do
    get "/orders", to: "orders#index"
    get "/orders/:id", to: "orders#show", as: "order_show"
    patch "/orders/:id", to: "orders#update", as: "order_cancel"
  end

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
end
