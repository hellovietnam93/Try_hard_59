Rails.application.routes.draw do
  get "/help", to: "static_pages#help"
  get "/contact", to: "static_pages#contact"
  get "/about", to: "static_pages#about"
  get "/signup", to: "users#new"
  root "static_pages#home"

  resources :users
end
