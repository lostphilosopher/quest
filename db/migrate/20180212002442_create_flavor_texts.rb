class CreateFlavorTexts < ActiveRecord::Migration[5.0]
  def change
    create_table :flavor_texts do |t|
      t.column :category, :integer
      t.column :trait, :integer
      t.text :body

      t.string :cmd_order
      t.string :cmd_success
      t.string :cmd_failed

      t.string :sci_order
      t.string :sci_success
      t.string :sci_failed

      t.string :med_order
      t.string :med_success
      t.string :med_failed

      t.string :tac_order
      t.string :tac_success
      t.string :tac_failed

      t.string :eng_order
      t.string :eng_success
      t.string :eng_failed

      t.timestamps
    end
  end
end
