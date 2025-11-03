class Match < ApplicationRecord
  attr_accessor :team_location

  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  validates :home_goals, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :away_goals, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :match_date, presence: true

  def winner
    return nil if home_goals == away_goals
    home_goals > away_goals ? home_team : away_team
  end

  def result_for_team(team)
    case team
    when home_team
      home_goals > away_goals ? 'V' : home_goals == away_goals ? 'E' : 'D'
    when away_team
      away_goals > home_goals ? 'V' : home_goals == away_goals ? 'E' : 'D'
    else
      nil
    end
  end
end
