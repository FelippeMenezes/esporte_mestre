class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :away_team, null: false, foreign_key: { to_table: :teams }
      t.integer :home_goals, default: 0
      t.integer :away_goals, default: 0
      t.datetime :match_date

      t.timestamps
    end
  end
end
