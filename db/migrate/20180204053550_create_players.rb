class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.integer :user_id, index: true
      t.string :name
      t.timestamps
    end
  end
end
