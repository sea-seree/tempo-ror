Rails.application.routes.draw do
  scope "(:locale)", locale: /en|th/ do
    resources :users

    get "/getuser" , to: "users#getall"

    root "users#index"
  end
end
