class AddFlavorTextToChallenge < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :flavor_text_id, :integer, index: true
  end
end
