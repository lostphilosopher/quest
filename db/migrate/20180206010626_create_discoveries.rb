class CreateDiscoveries < ActiveRecord::Migration[5.0]
  def change
    create_table :discoveries do |t|
      t.integer :player_id, index: true
      t.integer :game_id, index: true
      t.integer :user_id, index: true

      t.string :name
      t.string :description
      t.string :category
      t.integer :importance
      t.string :ship_name
      t.string :captain_name

      t.boolean :logged

      t.timestamps
    end
  end
end
