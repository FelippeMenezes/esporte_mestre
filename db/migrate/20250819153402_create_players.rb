class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :position
      t.integer :yellow_cards
      t.integer :red_cards
      t.boolean :injuries
      t.integer :goals_scored
      t.decimal :price
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
