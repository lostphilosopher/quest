class CreateShips < ActiveRecord::Migration[5.0]
  def change
    create_table :ships do |t|
      t.integer :game_id, index: true

      t.string :name

      t.boolean :commanded

      t.integer :cmd
      t.integer :eng
      t.integer :med
      t.integer :tac
      t.integer :sci

      t.timestamps
    end
  end
end
