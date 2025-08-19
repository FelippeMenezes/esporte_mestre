class CreateMarkets < ActiveRecord::Migration[7.1]
  def change
    create_table :markets do |t|
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
