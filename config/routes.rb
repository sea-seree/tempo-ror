Rails.application.routes.draw do
 resources :users

 get "/new", to: "users#new"
 root "users#index"
end
