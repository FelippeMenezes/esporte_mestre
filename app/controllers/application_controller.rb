class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def ensure_team_ownership(team)
    return redirect_to teams_path, alert: 'Acesso negado.' unless team.user == current_user
    true
  end

  def ensure_player_ownership(player)
    return redirect_to teams_path, alert: 'Acesso negado.' unless player.team.user == current_user
    true
  end
end
