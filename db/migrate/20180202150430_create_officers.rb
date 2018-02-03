class CreateOfficers < ActiveRecord::Migration[5.0]
  def change
    create_table :officers do |t|
      t.integer :game_id

      t.string :station

      t.string :name

      t.integer :cmd
      t.integer :dip
      t.integer :med
      t.integer :tac
      t.integer :sci

      t.timestamps
    end
  end
end
