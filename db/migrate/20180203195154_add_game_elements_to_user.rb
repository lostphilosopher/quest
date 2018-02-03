class AddGameElementsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :high_score, :integer
    add_column :users, :high_score_ship, :string
    add_column :users, :furthest_journey, :integer
    add_column :users, :furthest_journey_ship, :string

    add_column :games, :user_id, :integer, index: true
  end
end
