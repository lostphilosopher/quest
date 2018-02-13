class AddOfficerCostToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :officer_cost, :integer, default: 1000
    add_column :settings, :ship_cost, :integer, default: 10000
  end
end
