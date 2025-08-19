class Player < ApplicationRecord
  belongs_to :team

  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates :position, presence: true, inclusion: { in: %w[G D M A] }
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  scope :goalkeepers, -> { where(position: 'G') }
  scope :defenders, -> { where(position: 'D') }
  scope :midfielders, -> { where(position: 'M') }
  scope :attackers, -> { where(position: 'A') }

  def position_name
      case position
      when 'G' then 'Goleiro'
      when 'D' then 'Defensor'
      when 'M' then 'Meio-campo'
      when 'A' then 'Atacante'
      else position
      end
  end

  def market_value
    # Valor baseado no nível e posição
    case position
    when 'G' then level * 100000
    when 'D' then level * 80000
    when 'M' then level * 120000
    when 'A' then level * 150000
    else 50000
    end
  end


  def performance_rating
    # Rating baseado no nível com alguma variação
    base_rating = level * 10
    variation = rand(-10..10)
    [base_rating + variation, 10].max
  end

  private

  def team_position_limits
    # Limites de jogadores por posição para um time de 15 jogadores
    # G: Goleiro (2)
    # D: Defensor (5)
    # M: Meio-campo (5)
    # A: Atacante (3)
    # Total: 2 + 5 + 5 + 3 = 15

    case position
    when 'G'
      max_players = 2
    when 'D'
      max_players = 5
    when 'M'
      max_players = 5
    when 'A'
      max_players = 3
    else
      return # Posição inválida, a validação de inclusão já cuida disso
    end

    # Conta quantos jogadores já existem para esta posição no time, excluindo o jogador atual (se for uma atualização)
    existing_players_count = team.players.where(position: position).where.not(id: id).count

    if existing_players_count >= max_players
      errors.add(:position, "já atingiu o limite de #{max_players} jogadores para esta posição no time.")
    end
  end
end
