Rails.application.routes.draw do
  # Rota principal da aplicação
  root to: "pages#home"

  # Rotas geradas pelo Devise para autenticação de usuários
  devise_for :users

  # --- Início das rotas para :teams ---
  # GET /teams -> Lista todos os times
  get "teams", to: "teams#index", as: :teams

  # GET /teams/new -> Página do formulário para criar um novo time
  get "teams/new", to: "teams#new", as: :new_team

  # POST /teams -> Cria um novo time no banco de dados
  post "teams", to: "teams#create"

  # GET /teams/:id -> Mostra os detalhes de um time específico
  get "teams/:id", to: "teams#show", as: :team

  # GET /teams/:id/edit -> Página do formulário para editar um time
  get "teams/:id/edit", to: "teams#edit", as: :edit_team

  # PATCH/PUT /teams/:id -> Atualiza um time no banco de dados
  patch "teams/:id", to: "teams#update"
  put "teams/:id", to: "teams#update"

  # DELETE /teams/:id -> Remove um time do banco de dados
  delete "teams/:id", to: "teams#destroy"
  # --- Fim das rotas para :teams ---


  # --- Início das rotas para :campaigns (aninhadas em :teams com shallow: true) ---
  # Rotas aninhadas (precisam do ID do time)
  # GET /teams/:team_id/campaigns -> Lista todas as campanhas de um time
  get "teams/:team_id/campaigns", to: "campaigns#index", as: :team_campaigns

  # GET /teams/:team_id/campaigns/new -> Formulário para nova campanha de um time
  get "teams/:team_id/campaigns/new", to: "campaigns#new", as: :new_team_campaign

  # POST /teams/:team_id/campaigns -> Cria uma nova campanha para um time
  post "teams/:team_id/campaigns", to: "campaigns#create"

  # Rotas "shallow" (não precisam do ID do time no URL)
  # GET /campaigns/:id -> Mostra uma campanha específica
  get "campaigns/:id", to: "campaigns#show", as: :campaign

  # GET /campaigns/:id/edit -> Formulário para editar uma campanha
  get "campaigns/:id/edit", to: "campaigns#edit", as: :edit_campaign

  # PATCH/PUT /campaigns/:id -> Atualiza uma campanha
  patch "campaigns/:id", to: "campaigns#update"
  put "campaigns/:id", to: "campaigns#update"

  # DELETE /campaigns/:id -> Remove uma campanha
  delete "campaigns/:id", to: "campaigns#destroy"
  # --- Fim das rotas para :campaigns ---


  # --- Início das rotas para :players (aninhadas em :campaigns com shallow: true) ---
  # Rotas aninhadas
  get "campaigns/:campaign_id/players", to: "players#index", as: :campaign_players
  get "campaigns/:campaign_id/players/new", to: "players#new", as: :new_campaign_player
  post "campaigns/:campaign_id/players", to: "players#create"

  # Rotas "shallow"
  get "players/:id", to: "players#show", as: :player
  get "players/:id/edit", to: "players#edit", as: :edit_player
  patch "players/:id", to: "players#update"
  put "players/:id", to: "players#update"
  delete "players/:id", to: "players#destroy"
  # --- Fim das rotas para :players ---


  # --- Início das rotas para :market (recurso singular aninhado em :campaigns) ---
  # GET /campaigns/:campaign_id/market -> Mostra o mercado da campanha
  get "campaigns/:campaign_id/market", to: "markets#show", as: :campaign_market

  # PATCH/PUT /campaigns/:campaign_id/market -> Atualiza o mercado da campanha
  patch "campaigns/:campaign_id/market", to: "markets#update"
  put "campaigns/:campaign_id/market", to: "markets#update"
  # --- Fim das rotas para :market ---


  # --- Início das rotas para :matches (aninhadas em :campaigns com shallow: true) ---
  # Rotas aninhadas
  get "campaigns/:campaign_id/matches", to: "matches#index", as: :campaign_matches
  get "campaigns/:campaign_id/matches/new", to: "matches#new", as: :new_campaign_match
  post "campaigns/:campaign_id/matches", to: "matches#create"

  # Rotas "shallow"
  get "matches/:id", to: "matches#show", as: :match
  get "matches/:id/edit", to: "matches#edit", as: :edit_match
  patch "matches/:id", to: "matches#update"
  put "matches/:id", to: "matches#update"
  delete "matches/:id", to: "matches#destroy"
  # --- Fim das rotas para :matches ---


  # Rota para verificação de status da aplicação
  get "up" => "rails/health#show", as: :rails_health_check
end
