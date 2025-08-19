class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def index
    @players = @campaign.players
  end

  def show
  end

  def new
    @player = @campaign.players.build
  end

  def create
    @player = @campaign.players.build(player_params)
    if @player.save
      redirect_to campaign_player_path(@campaign, @player), notice: 'Jogador criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @player.update(player_params)
      redirect_to campaign_player_path(@campaign, @player), notice: 'Jogador atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @player.destroy
    redirect_to campaign_players_url(@campaign), notice: 'Jogador excluído com sucesso.'
  end

  private

  def set_campaign
    @campaign = current_user.teams.joins(:campaigns).find_by(campaigns: { id: params[:campaign_id]}).campaigns.find(params[:campaign_id])
  rescue NoMethodError, ActiveRecord::RecordNotFound
    redirect_to teams_url, alert: 'Campanha não encontrada ou você não tem permissão para acessá-la.'
  end

  def set_player
    @player = @campaign.players.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to campaign_players_url(@campaign), alert: 'Jogador não encontrado ou você não tem permissão para acessá-lo.'
  end

  def player_params
    params.require(:player).permit(:name, :position, :yellow_cards, :red_cards, :injuries, :goals_scored, :price)
  end
end
