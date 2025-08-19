class Team < ApplicationRecord
  belongs_to :user
  has_many :campaigns, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { scope: :user_id, message: "Você já tem um time com este nome." }
  validates :budget, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
