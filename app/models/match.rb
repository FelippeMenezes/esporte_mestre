class Match < ApplicationRecord
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
    if team == home_team
      return 'V' if home_goals > away_goals
      return 'E' if home_goals == away_goals
      return 'D'
    elsif team == away_team
      return 'V' if away_goals > home_goals
      return 'E' if home_goals == away_goals
      return 'D'
    end
  end
end
