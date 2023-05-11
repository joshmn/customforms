Rails.application.routes.draw do
  resources :custom_forms, only: [:index, :new, :create, :show] do
    scope module: :custom_forms do
      resources :responses
      resources :fields
    end
  end

  root to: 'custom_forms#index'
end
