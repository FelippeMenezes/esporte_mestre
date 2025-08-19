class Match < ApplicationRecord
  belongs_to :campaign

  validates :home_team_name, presence: true
  validates :away_team_name, presence: true
  validates :home_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :away_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :match_date, presence: true
end
