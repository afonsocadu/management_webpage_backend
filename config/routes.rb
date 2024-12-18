Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :employees
  resources :projects do
    collection do
      put 'update_employees'
      put 'update_technologies'
    end
  end
  resources :technologies
end
