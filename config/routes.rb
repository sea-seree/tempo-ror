Rails.application.routes.draw do
  scope "(:locale)", locale: /en|th/ do
    resources :users

    root "users#index"
  end
end
