Rails.application.routes.draw do
  devise_for :users
  
  resources :games do
    member do
      post :launch
    end
    resources :officers
    resources :challenges do
      post :accept
      post :retreat
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
