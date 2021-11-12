Rails.application.routes.draw do
 get "/login", to: "sessions#new"
 post "/login", to: "sessions#create"
 delete "/logout", to: "sessions#destroy"
 root :to => "sessions#new"
 get "/signup", to: "users#new"
 post "/signup", to: "users#create"
 get "/show/:id",to: "users#show"
 resources :users, only: %i(new create show)
 get "/static_pages/home", to:"static_pages#home", as: :home
 get "/static_pages/help", to:"static_pages#help", as: :help
end
