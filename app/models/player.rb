class Player < ApplicationRecord
  POSITION_NAMES = {
    'G' => 'Goleiro',
    'D' => 'Defensor',
    'M' => 'Meio-campo',
    'A' => 'Atacante'
  }.freeze

  MARKET_VALUE_MULTIPLIERS = {
    'G' => 10_000,
    'D' => 8_000,
    'M' => 12_000,
    'A' => 15_000
  }.freeze

  POSITION_LIMITS = {
    'G' => 2,
    'D' => 5,
    'M' => 5,
    'A' => 3
  }.freeze

  belongs_to :team

  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates :position, presence: true, inclusion: { in: POSITION_NAMES.keys }
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  validate :team_position_limits, on: :create

  scope :goalkeepers, -> { where(position: 'G') }
  scope :defenders, -> { where(position: 'D') }
  scope :midfielders, -> { where(position: 'M') }
  scope :attackers, -> { where(position: 'A') }

  def position_name
    POSITION_NAMES.fetch(position, position)
  end

  MARKET_VALUE_MULTIPLIERS = {
    'G' => 10_000,
    'D' => 8_000,
    'M' => 12_000,
    'A' => 15_000
  }.freeze

  def market_value
    level * MARKET_VALUE_MULTIPLIERS.fetch(position, 5_000)
  end

  def performance_rating
    base_rating = level * 10
    variation = rand(-10..10)
    [base_rating + variation, 10].max
  end

  private

  def team_position_limits
    max_players = POSITION_LIMITS[position]
    return unless max_players

    existing_players_count = team.players.where(position: position).where.not(id: id).count

    if existing_players_count >= max_players
      errors.add(:position, "já atingiu o limite de #{max_players} jogadores para esta posição no time.")
    end
  end
end
