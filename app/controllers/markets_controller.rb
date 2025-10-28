class MarketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:index, :buy_player, :sell_player]
  helper_method :sort_column, :sort_direction

  def index
    order_clause = sort_column == "market_value" ? market_value_order_sql : "players.#{sort_column}"

    @available_players = Player.joins(:team)
                               .where(teams: { is_user_team: false, campaign_id: @team.campaign_id })
                               .order(Arel.sql("#{order_clause} #{sort_direction}"))

    @my_players = @team.players.order(Arel.sql("#{order_clause} #{sort_direction}"))
  end

  def market_value_order_sql
    "CASE WHEN players.position = 'A' THEN players.level * 15000 " \
    "WHEN players.position = 'M' THEN players.level * 12000 " \
    "WHEN players.position = 'G' THEN players.level * 10000 " \
    "WHEN players.position = 'D' THEN players.level * 8000 " \
    "ELSE 5000 END"
  end

  def show
    @team = current_user.teams.find(params[:team_id])
    @player = Player.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to teams_path, alert: 'Time ou jogador não encontrado.'
  end

  def buy_player
    player = Player.find(params[:id])

    return redirect_to team_market_path(@team), alert: "Não foi possível comprar #{player.name}. Verifique seu orçamento." if @team.budget < player.market_value
    return redirect_to team_market_path(@team), alert: "Este jogador já está no seu time." if player.team == @team

    ActiveRecord::Base.transaction do
      @team.update!(budget: @team.budget - player.market_value)
      player.update!(team: @team)
    end

    redirect_to team_market_path(@team), notice: "#{player.name} comprado com sucesso!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to team_market_path(@team), alert: "Erro ao comprar #{player.name}: #{e.message}"
  rescue ActiveRecord::RecordNotFound
    redirect_to team_market_path(@team), alert: 'Jogador não encontrado.'
  end

  def sell_player
    player = Player.find(params[:id])

    return redirect_to team_market_path(@team), alert: "Você não pode vender este jogador." unless player.team == @team

    rival_teams = Team.where(campaign: @team.campaign, is_user_team: false).where.not(id: @team.id)
    return redirect_to market_path(@team), alert: "Não há times rivais disponíveis para a transferência." unless rival_teams.any?

    new_team = rival_teams.sample
    ActiveRecord::Base.transaction do
      @team.update!(budget: @team.budget + player.market_value)
      player.update!(team: new_team)
    end

    redirect_to team_market_path(@team), notice: "#{player.name} vendido com sucesso para #{new_team.name}!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to team_market_path(@team), alert: "Erro ao vender #{player.name}: #{e.message}"
  rescue ActiveRecord::RecordNotFound
    redirect_to team_market_path(@team), alert: 'Jogador não encontrado.'
  end

  private

  def sort_column
    %w[name position level market_value].include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def set_team
    @team = current_user.teams.find(params[:team_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to teams_path, alert: 'Time não encontrado.'
  end
end
