class Market < ApplicationRecord
  belongs_to :campaign

  validates :campaign_id, presence: true, uniqueness: true
end
