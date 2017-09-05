class CreatePeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :periods do |t|
      t.references :game
      t.integer :quarter
    end
  end
end
