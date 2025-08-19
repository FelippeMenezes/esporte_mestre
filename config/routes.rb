Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users
  
  # Rotas para Teams
  get '/teams', to: 'teams#index', as: 'teams'
  get '/teams/new', to: 'teams#new', as: 'new_team'
  post '/teams', to: 'teams#create'
  get '/teams/:id', to: 'teams#show', as: 'team'
  get '/teams/:id/edit', to: 'teams#edit', as: 'edit_team'
  patch '/teams/:id', to: 'teams#update'
  delete '/teams/:id', to: 'teams#destroy'
  
  # Rotas para Players
  get '/teams/:team_id/players', to: 'players#index', as: 'team_players'
  get '/teams/:team_id/players/new', to: 'players#new', as: 'new_team_player'
  post '/teams/:team_id/players', to: 'players#create'
  get '/players/:id', to: 'players#show', as: 'player'
  get '/players/:id/edit', to: 'players#edit', as: 'edit_player'
  patch '/players/:id', to: 'players#update'
  delete '/players/:id', to: 'players#destroy'
  
  # Rotas para Matches
  get '/teams/:team_id/matches', to: 'matches#index', as: 'team_matches'
  get '/teams/:team_id/matches/new', to: 'matches#new', as: 'new_team_match'
  post '/teams/:team_id/matches', to: 'matches#create'
  get '/matches/:id', to: 'matches#show', as: 'match'
  
  # Rotas para Market
  get "/teams/:team_id/market", to: "markets#index", as: 'market'
  get "/teams/:team_id/market/:id", to: "markets#show", as: 'market_player'
  post "/teams/:team_id/market/:id/buy", to: "markets#buy_player", as: 'buy_player'
  post "/teams/:team_id/market/:id/sell", to: "markets#sell_player", as: 'sell_player'
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
