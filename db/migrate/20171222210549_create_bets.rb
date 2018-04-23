class CreateBets < ActiveRecord::Migration[5.0]
  def change
    create_table :bets do |t|
      t.references :game
      t.string :desc
      t.integer :period
      t.float :away_prediction
      t.float :home_prediction
      t.float :away_score
      t.float :home_score
      t.float :away_line
      t.float :spread
      t.float :total
    end
  end
end
