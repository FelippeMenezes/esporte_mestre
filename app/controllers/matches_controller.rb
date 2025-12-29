class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:index, :new, :create, :play]
  before_action :set_match, only: [:show, :play]

  def index
    @matches = @team.all_matches.order(match_date: :desc)
  end

  def show
    @goal_events = generate_goal_events(@match)
  end

  def new
    @match = Match.new
    @rival_teams = @team.campaign.rival_teams
  end

  def create
    @match = Match.new(match_params)
    @match.match_date = Time.current

    if params[:match][:team_location] == 'away'
      @match.away_team = @team
      @match.home_team_id = params[:match][:away_team_id] # O adversário é o time da casa
    else
      @match.home_team = @team # Comportamento padrão
    end

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
      redirect_to team_match_path(@team, @match)
    else
      @rival_teams = @team.campaign.rival_teams
      render :new
    end
  end

  def play
    unless @team.can_play_match?
      redirect_to team_championship_path(@team, @match.championship), alert: 'Seu time precisa de 11 jogadores.' and return
    end

    # Simula o jogo do usuário
    simulate_match(@match)
    @match.match_date = Time.current
    @match.status = :finished
    @match.save!

    # Simula o restante da rodada (CPU vs CPU)
    if @match.championship
      other_matches = @match.championship.matches.where(round: @match.round, status: :scheduled).where.not(id: @match.id)
      other_matches.each do |m|
        simulate_match(m)
        m.match_date = Time.current
        m.status = :finished
        m.save!
      end
    end

    redirect_to team_match_path(@team, @match), notice: "Partida finalizada!"
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:away_team_id, :team_location)
  end

  def simulate_match(match)
    home_strength = calculate_team_strength(match.home_team)
    away_strength = calculate_team_strength(match.away_team)

    home_performance = home_strength + rand(-1..3)
    away_performance = away_strength + rand(-1..3)

    match.home_goals = [(home_performance / rand(2..5)), 0].max
    match.away_goals = [(away_performance / rand(2..5)), 0].max
  end

  def calculate_team_strength(team)
    team.players.average(:level).to_i
  end

  def generate_goal_events(match)
    events = []
    match.home_goals.times do
      events << { minute: rand(1..90), team_name: match.home_team.name, type: 'home' }
    end
    match.away_goals.times do
      events << { minute: rand(1..90), team_name: match.away_team.name, type: 'away' }
    end
    events.sort_by { |event| event[:minute] }
  end
end
