class Championship < ApplicationRecord
  belongs_to :campaign
  has_many :matches, dependent: :destroy
  has_many :teams, through: :campaign

  validates :name, presence: true

  def generate_matches!
    teams_list = campaign.teams.to_a
    return if teams_list.size < 2

    rounds = (teams_list.size - 1) * 2
    matches_per_round = teams_list.size / 2

    (1..rounds).each do |round|
      matches_per_round.times do |i|
        home = teams_list[i]
        away = teams_list[teams_list.size - 1 - i]

        # Alternar mando de campo
        home_team, away_team = round.even? ? [away, home] : [home, away]

        matches.create!(home_team: home_team, away_team: away_team, round: round, status: :scheduled)
      end
      teams_list = [teams_list[0]] + teams_list[1..-1].rotate(-1)
    end
  end
end
