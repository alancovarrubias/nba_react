class CreateIntervals < ActiveRecord::Migration[5.0]
  def change
    create_table :intervals do |t|
      t.references :start_date, class_name: "GameDate"
      t.references :end_date, class_name: "GameDate"
      t.integer :games_played
    end
  end
end
