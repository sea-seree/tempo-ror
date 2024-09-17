Rails.application.routes.draw do
  scope "(:locale)", locale: /en|th/ do
    resources :users do
      member do
        get 'confirm_delete'
      end
    end

    get "/getuser" , to: "users#getall"

    root "users#index"
  end
end
