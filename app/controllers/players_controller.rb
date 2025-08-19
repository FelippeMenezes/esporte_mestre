class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:index, :new, :create]
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def index
    @players = @team.players.order(:position, :name)
  end

  def show
  end

  def new
    @player = @team.players.build
  end

  def create
    @player = @team.players.build(player_params)

    if @player.save
      redirect_to team_players_path(@team), notice: 'Jogador criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @player.update(player_params)
      redirect_to @player, notice: 'Jogador atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    team = @player.team
    @player.destroy
    redirect_to team_players_path(team), notice: 'Jogador excluído com sucesso.'
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def set_player
    @player = Player.find(params[:id])
    # Verificar se o jogador pertence a um time do usuário atual
    unless @player.team.user == current_user
      redirect_to teams_path, alert: 'Acesso negado.'
    end
  end

  def player_params
    params.require(:player).permit(:name, :position, :level)
  end
end
