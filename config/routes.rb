Rails.application.routes.draw do
  resources :employees, only: %i[index destroy] do
  end
end
