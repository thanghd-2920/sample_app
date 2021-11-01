Rails.application.routes.draw do

    get"/static_pages/home", to:"static_pages#home",as: :home
    get "/static_pages/help",to:"static_pages#help",as: :help
end
