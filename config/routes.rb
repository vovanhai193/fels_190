Rails.application.routes.draw do
  root "static_pages#home"
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  resources :users do
    member do
      get "followers" => "followers#index"
      get "following" => "following#index"
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :categories, only: [:index, :show] do
    resources :lessons, only: :create
  end
  resources :lessons, only: [:show, :update, :destroy]
  resources :words, only: :index
  namespace :admin do
    root "users#index"
    resources :users, only: [:index, :destroy]
    resources :categories do
      resources :words, except: [:index, :show]
    end
    resources :lessons, only: [:index, :destroy]
  end
end
