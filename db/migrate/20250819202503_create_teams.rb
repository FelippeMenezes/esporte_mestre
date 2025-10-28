class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.decimal :budget, precision: 10, scale: 2, default: 500000.00
      t.references :user, null: true, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.boolean :is_user_team, default: false

      t.timestamps
    end
  end
end
