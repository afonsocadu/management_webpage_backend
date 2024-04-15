Rails.application.routes.draw do
  resources :employees
  resources :projects do
    collection do
      put 'update_employees'
      put 'update_technologies'
    end
  end
  resources :technologies
end
