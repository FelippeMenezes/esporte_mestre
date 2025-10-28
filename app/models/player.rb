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
    case position
    when 'G' then level * 10000
    when 'D' then level * 8000
    when 'M' then level * 12000
    when 'A' then level * 15000
    else 5000
    end
  end


  def performance_rating
    base_rating = level * 10
    variation = rand(-10..10)
    [base_rating + variation, 10].max
  end

  private

  def team_position_limits
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
      return
    end

    existing_players_count = team.players.where(position: position).where.not(id: id).count

    if existing_players_count >= max_players
      errors.add(:position, "já atingiu o limite de #{max_players} jogadores para esta posição no time.")
    end
  end
end
