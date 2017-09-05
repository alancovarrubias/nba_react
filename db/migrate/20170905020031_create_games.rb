class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.references :season
      t.references :game_date
      t.references :away_team, references: :team
      t.references :home_team, references: :team
    end
  end
end
