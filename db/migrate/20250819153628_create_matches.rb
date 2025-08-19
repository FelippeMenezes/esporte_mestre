class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.string :home_team_name
      t.string :away_team_name
      t.integer :home_score
      t.integer :away_score
      t.datetime :match_date
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
