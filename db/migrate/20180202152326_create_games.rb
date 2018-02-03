class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :progress, default: 0
      t.integer :points, default: 0

      t.timestamps
    end
  end
end
