Rails.application.routes.draw do
  devise_for :users

  root 'dashboard#index'

  resources :vpn_servers do
    member do
      get :start
      get :stop
    end
    resources :peers, only: [:index, :new, :create]
  end

  resources :peers do
    member do
      get :generate_keys
      get :download_config
    end
  end

  get 'dashboard', to: 'dashboard#index'
  get 'health', to: proc { [200, {}, ['OK']] }
end
