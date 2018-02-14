class AddDamageMultiplierToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :damage_multiplier, :integer, default: 1
  end
end
