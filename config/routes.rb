Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  resources :teams do
    resources :players, only: [:index, :create]
    resources :matches, only: [:index, :new, :create]
    resource :market, only: [:show], controller: 'markets' do
      get '', action: :index
      get ':id', action: :show, as: :player
      post ':id/buy', action: :buy_player, as: :buy_player
      post ':id/sell', action: :sell_player, as: :sell_player
    end
  end

  resources :players, only: [:show, :update]
  resources :matches, only: [:show]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
