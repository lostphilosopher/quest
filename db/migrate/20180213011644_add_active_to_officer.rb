class AddActiveToOfficer < ActiveRecord::Migration[5.0]
  def change
    add_column :officers, :active, :boolean
  end
end
