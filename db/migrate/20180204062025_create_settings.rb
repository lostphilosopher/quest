class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      # Chances, out of 100
      t.integer :encoutering_challenge, default: 70
      # Static Numbers
      t.integer :challenge_bump, default: 150
      t.integer :failure_point_divisor, default: 2
      t.integer :retreat_points_divisor, default: 1
      t.integer :retreat_progress_cost, default: 2
      t.integer :retreat_fuel_cost, default: 5
      t.integer :officers_to_choose_from, default: 10
      t.integer :ships_to_choose_from, default: 3
      t.integer :refuel_countdown_hours, default: 24
      t.integer :max_fuel, default: 100
      t.integer :max_shields, default: 100
      t.integer :supply_min, default: 5
      t.integer :supply_max, default: 10
      t.integer :max_fuel_percentage_correction, default: 1
      t.integer :max_shields_percentage_correction, default: 1
      t.timestamps
    end
  end
end
