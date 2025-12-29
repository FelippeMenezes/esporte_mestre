class ChampionshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team

  def create
    # Cria um novo campeonato para a campanha atual
    @campaign = @team.campaign
    season_number = @campaign.championships.count + 1
    @championship = @campaign.championships.create!(name: "Divisão Principal - Temporada #{season_number}", season: season_number)

    # Gera os jogos
    @championship.generate_matches!

    redirect_to team_championship_path(@team, @championship), notice: 'Campeonato iniciado com sucesso!'
  end

  def show
    @championship = @team.campaign.championships.find(params[:id])

    # Classificação simples (pode ser movida para um Service ou Model depois)
    @standings = @team.campaign.teams.sort_by { |t| [ -t.wins, -t.goal_difference ] }

    # Próxima partida do usuário neste campeonato
    @next_match = @championship.matches.scheduled.where("home_team_id = ? OR away_team_id = ?", @team.id, @team.id).order(:round).first
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end
end
