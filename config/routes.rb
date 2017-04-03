Rails.application.routes.draw do
  resources :locations
  devise_for :users

  root to: "locations#index"
end
