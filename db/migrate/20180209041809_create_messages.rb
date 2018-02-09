class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :game_id, index: true
      t.string :source
      t.string :body
      t.timestamps
    end
  end
end
