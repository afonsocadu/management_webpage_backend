Rails.application.routes.draw do
  resources :employees, only: %i[index destroy update create] do
  end

  resources :projects, only: %i[index]
end
