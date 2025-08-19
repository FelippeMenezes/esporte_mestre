class MarketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign
  before_action :set_market

  def show
  end

  def update
    if @market.update(market_params)
      redirect_to campaign_market_path(@campaign), notice: 'Mercado atualizado com sucesso.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_campaign
    @campaign = current_user.teams.joins(:campaigns).find_by(campaigns: { id: params[:campaign_id]}).campaigns.find(params[:campaign_id])
  rescue NoMethodError, ActiveRecord::RecordNotFound
    redirect_to teams_url, alert: 'Campanha não encontrada ou você não tem permissão para acessá-la.'
  end

  def set_market
    @market = @campaign.market || @campaign.create_market
  end

  def market_params
    params.fetch(:market, {}).permit()
  end
end
