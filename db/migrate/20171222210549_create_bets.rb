class CreateBets < ActiveRecord::Migration[5.0]
  def change
    create_table :bets do |t|
      t.references :game
      t.string :desc
      t.integer :period
      t.float :score
    end
  end
end
