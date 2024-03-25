Rails.application.routes.draw do
  resources :employees
  resources :projects do
    collection do
      put 'update_employees'
      put 'update_technologies'
      put 'update_title'
    end
  end
  resources :technologies
end
