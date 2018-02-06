class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.integer :player_id, index: true
      t.integer :user_id, index: true

      t.string :voyage_name
      t.string :ship_name
      t.string :captain_name

      t.integer :progress
      t.integer :points
      t.integer :discoveries
      t.timestamps
    end
  end
end
