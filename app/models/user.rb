class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :teams, dependent: :destroy

  def user_teams
    teams.where(is_user_team: true)
  end
end
