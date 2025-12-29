class AddDetailsToMatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :matches, :championship, null: true, foreign_key: true
    add_column :matches, :round, :integer
    add_column :matches, :status, :integer, default: 0 # 0: scheduled, 1: finished

    # Permitir nulos temporariamente para gols em jogos agendados
    change_column_null :matches, :home_goals, true
    change_column_null :matches, :away_goals, true
  end
end
