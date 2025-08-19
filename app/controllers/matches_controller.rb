class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  def index
    @matches = @campaign.matches
  end

  def show
  end

  def new
    @match = @campaign.matches.build
  end

  def create
    @match = @campaign.matches.build(match_params)
    if @match.save
      redirect_to campaign_match_path(@campaign, @match), notice: 'Partida criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @match.update(match_params)
      redirect_to campaign_match_path(@campaign, @match), notice: 'Partida atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @match.destroy
  redirect_to campaign_matches_url(@campaign), notice: 'Partida excluída com sucesso.'
  end

  private

  def set_campaign
    @campaign = current_user.teams.joins(:campaigns).find_by(campaigns: { id: params[:campaign_id]}).campaigns.find(params[:campaign_id])
  rescue NoMethodError, ActiveRecord::RecordNotFound
    redirect_to teams_url, alert: 'Campanha não encontrada ou você não tem permissão para acessá-la.'
  end

  def set_match
    @match = @campaign.matches.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to campaign_matches_url(@campaign), alert: 'Partida não encontrada ou você não tem permissão para acessá-la.'
  end

  def match_params
    params.require(:match).permit(:home_team_name, :away_team_name, :home_score, :away_score, :match_date)
  end
end
