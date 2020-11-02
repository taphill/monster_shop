Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/merchant", to: "welcome#merchant"
  get "/admin", to: "welcome#admin"

  namespace :admin do
    get "/users", to: "users#index"
    get "/orders/:order_id", to: "orders#update"
    namespace :merchants do
      scope '/:merchant_id/' do
        get "/items", to: "items#index"
        get "/items/new", to: "items#new"
        post "/items", to: "items#create", as: "create_item"
      end
    end
  end

  resources :merchants

  namespace :merchants do
    scope '/:merchant_id/' do
      get "/items", to: "items#index"
      get "/items/new", to: "items#new"
      post "/items", to: "items#create", as: "create_item"
    end
  end

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show", as: 'item'
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  delete "/items/:id", to: "items#destroy"

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
