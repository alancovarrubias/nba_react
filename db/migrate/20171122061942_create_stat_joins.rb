class CreateStatJoins < ActiveRecord::Migration[5.0]
  def change
    create_table :stat_joins do |t|
      t.references :model, polymorphic: true
      t.references :interval, polymorphic: true
    end
  end
end
