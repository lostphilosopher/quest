Rails.application.routes.draw do

  resources :flavor_texts
  resources :messages
  resources :discoveries
  resources :records
  resources :settings
  resources :players
  resources :regions
  devise_for :users

  resources :games do
    member do
      post :launch
      get :end
      get :starbase
      get :status
    end
    resources :officers
    resources :ships
    resources :challenges do
      post :accept
      post :retreat
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
