class Campaign < ApplicationRecord
  belongs_to :team
  has_many :players, dependent: :destroy 

  has_many :matches, dependent: :destroy

  has_one :market, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :team_id, message: "Você já tem uma campanha com este nome neste time." }
  validates :start_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "deve ser depois da data de início")
    end
  end
end
