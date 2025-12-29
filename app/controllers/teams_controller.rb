class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = current_user.teams.includes(:campaign, :players)
  end

  def show
    @players = @team.players.order(:position, :name)
    @recent_matches = @team.all_matches.includes(:home_team, :away_team)
                           .where.not(match_date: nil)
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
    @team.budget = 500_000.00

    ActiveRecord::Base.transaction do
      campaign = Campaign.create!(name: "Campanha de #{@team.name}")
      @team.campaign = campaign

      if @team.save
        create_rival_teams(campaign)
        create_players_for_team(@team)

        redirect_to @team, notice: team_creation_success_message
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Erro ao criar time: #{e.message}"
    @team.errors.add(:base, "Erro interno: #{e.message}")
    render :new, status: :unprocessable_entity
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
      total_matches: team.all_matches.where.not(match_date: nil).count,
      wins: team.wins,
      draws: team.draws,
      losses: team.losses,
      goals_for: team.goals_for,
      goals_against: team.goals_against,
      goal_difference: team.goal_difference
    }
  end

  def create_players_for_team(team)
    positions = %w[G G D D D D D M M M M M A A A]

    positions.each do |position|
      player = Player.new(
        name: generate_player_name,
        position: position,
        level: rand(1..10),
        team: team
      )
      player.save!
    end
  end

  def create_rival_teams(campaign)
    9.times do
      rival_team = Team.new(
        name: generate_team_name,
        campaign: campaign,
        is_user_team: false,
        budget: rand(30_000..60_000)
      )
      rival_team.save!
      create_players_for_team(rival_team)
    end
  end

  def team_creation_success_message
    <<~MSG.squish
      Time criado com sucesso! Sua campanha foi iniciada.
      Utilize o MENU para gerenciar seu time. Acesse: Seus Jogadores, Suas Partidas, Crie Partida, Mercado, Seus Times
    MSG
  end

  def generate_player_name
    first_names = [
      'João', 'Raul', 'Igor', 'Yago', 'Caio', 'Davi', 'Hugo', 'Beto', 'Enzo', 'José', 'Luiz',
      'Juan', 'Alan', 'Eder', 'Ivan', 'Luca', 'Nilo', 'Otto', 'Cauã', 'Ravi', 'Yuri', 'Zeca',
      'Noah', 'Theo', 'Gael', 'Ciro', 'Eros', 'Iago', 'Luan', 'Alex', 'Davi',
      'Dudu', 'Eloi', 'Guto', 'Iago', 'Jean', 'Joel', 'Kadu', 'Léo', 'Levi', 'Max',
      'Ney', 'Pery', 'Rui', 'Tito', 'André', 'Bruno', 'César', 'Diego', 'Elias', 'Fábio',
      'Gomes', 'Hélio', 'Isaac', 'Jorge', 'Kevin', 'Lucas', 'Mário', 'Natan', 'Osmar',
      'Paulo', 'Ruan', 'Silas', 'Tiago', 'Vitor', 'Ariel', 'Bento', 'Cauê', 'Denis',
      'Érico', 'Félix', 'Guido', 'Ítalo', 'Jonas', 'Lauro', 'Mauro', 'Nunes', 'Oscar',
      'Piero', 'Renan', 'Simão', 'Túlio', 'Vasco', 'Abner', 'Breno', 'Clóvis', 'Dário',
      'Edson', 'Freder', 'Gilmar', 'Irineu', 'Jaime', 'Luan', 'Marco', 'Tomás'
    ]
    last_names = [
      'Silva', 'Lima', 'Rosa', 'Dias', 'Reis', 'Cruz', 'Melo', 'Pina', 'Maia', 'Sena', 'Lira',
      'Vale', 'Gois', 'Lapa', 'Mota', 'Paes', 'Rios', 'Lage', 'Sá', 'Neto', 'Nery', 'Real',
      'Vaz', 'Boni', 'Sena', 'Faro', 'Gama', 'Lous', 'Mata', 'Leal', 'Vane', 'Ledo', 'Luz',
      'Ares', 'Reis', 'Souza', 'Costa', 'Alves', 'Matos', 'Pinto', 'Ramos', 'Rocha', 'Lopes',
      'Gomes', 'Frota', 'Brito', 'Mello', 'Sales', 'Paiva', 'Pires', 'Teles', 'Aires', 'Nunes',
      'Vieira', 'Neves', 'Dutra', 'Moura', 'Muniz', 'Faria', 'Assis', 'Leite', 'Serra', 'Prado',
      'Borba', 'Froes', 'Viana', 'Ayres', 'Braga', 'Baros', 'Porto', 'Sique', ' Abreu', 'Godoy',
      'Cunha', 'Regis', 'Aguiar', 'Lemos', 'Frois', 'Ferraz', 'Maia', 'Vidal''Paulista', 'Carioca',
      'Paraíba', 'Mineiro', 'Gaúcho', 'Pará', 'Goiano', 'Baiano'
    ]
    "#{first_names.sample} #{last_names.sample}"
  end

  def generate_team_name
    team_name = ['Cosmos', 'Nova', 'Capital', 'Solar', 'Tropical', 'Rural', 'Opera', 'Oasis',
    'Mineral', 'Animal', 'Formula', 'Lava', 'Natural', 'Panda', 'Prisma', 'Zebra', 'Elite',
    'Atlas',  'Base', 'Canal', 'Coral', 'Junior']
    prefixes = ['Premier', 'Metro', 'Central', 'Social', 'Original', 'Naval', 'Principal',
    'Real', 'Regular', 'Terminal', 'Titan', 'Bravo', 'Delta', 'Popular']
    suffixes = ['FC', 'AA', 'UA', 'CR', 'AF', 'CF', 'AC', 'RF', 'RC', 'UC']

    "#{team_name.sample} #{prefixes.sample} #{suffixes.sample}"
  end
end
