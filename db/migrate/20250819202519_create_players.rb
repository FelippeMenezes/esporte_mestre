class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.string :position, null: false
      t.integer :level, default: 1
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end

    add_index :players, :position
  end
end
