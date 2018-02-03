class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.integer :user_id
      t.string :ship
      t.string :name
      t.string :description
      t.integer :range
      t.timestamps
    end
  end
end
