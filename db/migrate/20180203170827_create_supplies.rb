class CreateSupplies < ActiveRecord::Migration[5.0]
  def change
    create_table :supplies do |t|
      t.integer :game_id, index: true

      t.integer :fuel
      t.integer :shields

      t.integer :cmd
      t.integer :eng
      t.integer :med
      t.integer :tac
      t.integer :sci

      t.timestamps
    end
  end
end
