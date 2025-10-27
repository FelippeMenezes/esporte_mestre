class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = current_user.teams.includes(:campaign, :players)
  end

  def show
    @players = @team.players.order(:position, :name)
    @recent_matches = @team.all_matches.includes(:home_team, :away_team)
                           .order(match_date: :desc).limit(5)
    @team_stats = calculate_team_stats(@team)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    @team.is_user_team = true
    @team.budget = 10000000.00

    begin
      ActiveRecord::Base.transaction do
        campaign = Campaign.create!(name: "Campanha de #{@team.name}")
        @team.campaign = campaign

        if @team.save
          9.times do |i|
            rival_team = Team.new(
              name: generate_team_name,
              campaign: campaign,
              is_user_team: false,
              budget: rand(800000..1200000)
            )
            unless rival_team.save
              puts "ERROS AO SALVAR TIME RIVAL: #{rival_team.errors.full_messages.join(", ")}"
              raise ActiveRecord::Rollback
            end
            create_players_for_team(rival_team)
          end
          
          create_players_for_team(@team)

          redirect_to @team, notice: "Time criado com sucesso!
                                    Sua campanha foi iniciada.
                                    Utilize o MENU para gerenciar seu time.
                                    Acesse:
                                    
                                    Seus Jogadores
                                    Suas Partidas
                                    Crie Partida
                                    Mercado
                                    Seus Times"
        else
          puts "ERROS AO SALVAR TIME: #{@team.errors.full_messages.join(", ")}"
          render :new, status: :unprocessable_entity
        end
      end
    rescue => e
      Rails.logger.error "Erro ao criar time: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      @team.errors.add(:base, "Erro interno: #{e.message}")
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
    campaign = @team.campaign
    @team.destroy
    
    if campaign && campaign.teams.where(is_user_team: true).empty?
      campaign.destroy
    end
    
    redirect_to root_path, notice: 'Time excluído com sucesso.'
  end

  private

  def set_team
    @team = current_user.teams.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to teams_path, alert: 'Time não encontrado.'
  end

  def team_params
    params.require(:team).permit(:name)
  end

  def calculate_team_stats(team)
    {
      total_matches: team.all_matches.count,
      wins: team.wins,
      draws: team.draws,
      losses: team.losses,
      goals_for: team.goals_for,
      goals_against: team.goals_against,
      goal_difference: team.goal_difference,
      points: team.points
    }
  end

  def create_players_for_team(team)
    positions = ['G', 'G', 'D', 'D', 'D', 'D', 'D', 'M', 'M', 'M', 'M', 'M', 'A', 'A', 'A']
    
    positions.each_with_index do |position, index|
      player = Player.new(
        name: generate_player_name,
        position: position,
        level: rand(1..10),
        team: team
      )
      unless player.save
        puts "ERROS AO SALVAR JOGADOR: #{player.errors.full_messages.join(", ")}"
        puts "Time do jogador: #{team.name}"
        puts "Posição do jogador: #{position}"
        raise ActiveRecord::Rollback
      end
    end
  end

  def generate_player_name
    first_names = [
      'João', 'Pedro', 'Carlos', 'Luis', 'André', 'Rafael', 'Bruno', 'Diego', 'Felipe', 'Gabriel',
      'Marcos', 'Paulo', 'Ricardo', 'Fernando', 'Roberto', 'Alexandre', 'Rodrigo', 'Daniel', 'Thiago', 'Leonardo'
    ]
    last_names = [
      'Silva', 'Santos', 'Oliveira', 'Souza', 'Lima', 'Costa', 'Pereira', 'Alves', 'Ferreira', 'Rodrigues',
      'Nascimento', 'Carvalho', 'Araújo', 'Gomes', 'Barbosa', 'Rocha', 'Dias', 'Monteiro', 'Cardoso', 'Reis'
    ]
    
    "#{first_names.sample} #{last_names.sample}"
  end

  def generate_team_name
    prefixes = ['FC', 'SC', 'EC', 'AC', 'CR']
    cities = [
      'São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Salvador', 'Brasília',
      'Fortaleza', 'Manaus', 'Curitiba', 'Recife', 'Porto Alegre'
    ]
    suffixes = ['United', 'City', 'Rovers', 'Athletic', 'Sporting']
    
    "#{prefixes.sample} #{cities.sample} #{suffixes.sample}"
  end
end
