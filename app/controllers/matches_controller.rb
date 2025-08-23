class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:index, :new, :create]
  before_action :set_match, only: [:show]

  def index
    @matches = @team.all_matches.order(match_date: :desc)
  end

  def show
  end

  def new
    @match = Match.new
    @rival_teams = @team.campaign.rival_teams
  end

  def create
    @match = Match.new(match_params)
    @match.home_team = @team
    @match.match_date = Time.current

    unless @team.can_play_match?
      @rival_teams = @team.campaign.rival_teams
      flash.now[:alert] = 'Seu time precisa ter pelo menos 11 jogadores para jogar uma partida.'
      render :new and return
    end

    if @match.away_team.nil?
      @rival_teams = @team.campaign.rival_teams
      flash.now[:alert] = 'Você precisa selecionar um time adversário.'
      render :new and return
    end

    simulate_match(@match)
    if @match.save
      redirect_to @match, notice: 'Partida realizada com sucesso!'
    else
      @rival_teams = @team.campaign.rival_teams
      render :new
    end
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:away_team_id)
  end

  def simulate_match(match)
    # Simulação simples baseada no nível médio dos jogadores
    home_strength = calculate_team_strength(match.home_team)
    away_strength = calculate_team_strength(match.away_team)
    
    # Adicionar fator aleatório
    home_performance = home_strength + rand(0..3)
    away_performance = away_strength + rand(0..3)
    
    # Calcular gols baseado na performance
    match.home_goals = [home_performance / 2, 0].max
    match.away_goals = [away_performance / 2, 0].max
  end

  def calculate_team_strength(team)
    return 0 if team.players.empty?
    
    team.players.average(:level).to_i
  end
end
