class Player < ApplicationRecord
  belongs_to :campaign

  validates :name, presence: true
  validates :position, presence: true
  validates :yellow_cards, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :red_cards, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :goals_scored, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
