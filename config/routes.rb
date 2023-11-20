Rails.application.routes.draw do
  resources :employees, only: %i[index] do
  end
end
