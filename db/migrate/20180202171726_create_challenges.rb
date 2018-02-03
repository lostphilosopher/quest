class CreateChallenges < ActiveRecord::Migration[5.0]
  def change
    create_table :challenges do |t|
      t.integer :game_id, index: true

      t.string :name
      t.string :description

      t.integer :level
      t.integer :value
      t.string :trait
      t.timestamps
    end
  end
end
