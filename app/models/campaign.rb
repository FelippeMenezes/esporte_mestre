class Campaign < ApplicationRecord
  has_many :teams, dependent: :destroy

  validates :name, presence: true

  def user_team
    teams.find_by(is_user_team: true)
  end

  def rival_teams
    teams.where(is_user_team: false)
  end
end
