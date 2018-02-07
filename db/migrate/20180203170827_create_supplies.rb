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

      t.timestamp :last_eng_at
      t.timestamp :last_sci_at
      t.timestamp :last_med_at
      t.timestamp :last_tac_at
      t.timestamp :last_cmd_at
      
      t.timestamps
    end
  end
end
