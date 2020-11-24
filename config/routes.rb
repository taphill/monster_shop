Rails.application.routes.draw do
  root 'welcome#index'

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  patch "/profile", to: "users#update"
  get "/profile/edit", to: "users#edit"
  namespace :profile do
    resources :orders, only: [:index, :show, :update]
  end

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
    resources :discounts
    resources :items, except: [:show]
    resources :orders, only: [:show, :update]
  end

  resources :merchants, except: [:delete] do
    resources :items, only: [:index]
  end

  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  resources :orders, only: [:new, :create, :show]

  resource :cart, only: [:show, :destroy]
  post "/cart/:item_id", to: "carts#create"
  patch "/cart/:item_id", to: "carts#update"
  delete "/cart/:item_id", to: "carts#destroy"
end
