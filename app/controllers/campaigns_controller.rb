class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  def index
    @campaigns = @team.campaigns
  end

  def show
  end

  def new
    @campaign = @team.campaigns.build
  end

  def create
    @campaign = @team.campaigns.build(campaign_params)
    if @campaign.save
      redirect_to team_campaign_path(@team, @campaign), notice: 'Campanha criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to team_campaign_path(@team, @campaign), notice: 'Campanha atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  @campaign.destroy
    redirect_to team_campaigns_url(@team), notice: 'Campanha excluída com sucesso.'
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to teams_url, alert: 'Time não encontrado ou você não tem permissão para acessá-lo.'
  end

  def set_campaign
    @campaign = @team.campaigns.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to team_campaigns_url(@team), alert: 'Campanha não encontrada ou você não tem permissão para acessá-la.'
  end

  def campaign_params
    params.require(:campaign).permit(:name, :start_date, :end_date)
  end
end
