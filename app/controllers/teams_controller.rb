class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = current_user.teams
  end

  def show
  end

  def new
    @team = current_user.teams.build
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      redirect_to @team, notice: 'Time criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'Time atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Time excluído com sucesso.'
  end

  private

  def set_team
    @team = current_user.teams.find(params[:id])
    redirect_to teams_url, alert: 'Time não encontrado ou você não tem permissão para acessá-lo.'
  end

  def team_params
    params.require(:team).permit(:name, :budget)
  end
end
