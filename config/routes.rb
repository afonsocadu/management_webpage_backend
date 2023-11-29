Rails.application.routes.draw do
  resources :employees, only: %i[index destroy update] do
  end

  resources :projects, only: %i[index]
end
