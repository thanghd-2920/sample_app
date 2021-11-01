Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root :to => "sessions#new"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/show/:id",to: "users#show"
  get "/edit/:id", to: "users#edit"
  resources :users, only: %i(new create show edit update index destroy)
  resources :account_activations, only: :edit
  get "/static_pages/home", to:"static_pages#home", as: :home
  get "/static_pages/help", to:"static_pages#help", as: :help
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
end
