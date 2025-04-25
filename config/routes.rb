Rails.application.routes.draw do

  resources :employees do
    collection do
      post 'import_file'
    end
  end

  resources :projects do
    collection do
      put 'update_employees'
      put 'update_technologies'
    end
  end

  resources :technologies
end
