class CreateOfficers < ActiveRecord::Migration[5.0]
  def change
    create_table :officers do |t|
      t.integer :game_id, index: true

      t.string :station

      t.string :name

      t.integer :cmd
      t.integer :eng
      t.integer :med
      t.integer :tac
      t.integer :sci

      t.timestamps
    end
  end
end
