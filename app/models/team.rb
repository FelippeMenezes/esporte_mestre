class Team < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :campaign, optional: true
  has_many :players, dependent: :destroy
  has_many :home_matches, class_name: 'Match', foreign_key: 'home_team_id', dependent: :destroy
  has_many :away_matches, class_name: 'Match', foreign_key: 'away_team_id', dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :budget, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def all_matches
    Match.where(home_team_id: id).or(Match.where(away_team_id: id))
  end

  def can_play_match?
    players.count >= 11
  end

  def total_players
    players.count
  end

  def wins
    all_matches.select { |match| match.winner == self }.count
  end

  def draws
    all_matches.select { |match| match.winner.nil? }.count
  end

  def losses
    all_matches.count - wins - draws
  end

  def goals_for
    home_matches.sum(:home_goals) + away_matches.sum(:away_goals)
  end

  def goals_against
    home_matches.sum(:away_goals) + away_matches.sum(:home_goals)
  end


  def goal_difference
    goals_for - goals_against
  end

  def points
    wins * 3 + draws
  end
end