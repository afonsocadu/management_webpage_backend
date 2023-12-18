Rails.application.routes.draw do
  resources :employees

  resources :projects, only: [:index]
end
