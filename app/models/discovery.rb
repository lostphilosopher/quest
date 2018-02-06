class Discovery < ApplicationRecord
  belongs_to :game
  after_create :roll

  def self.unclaimed(user_id)
    where(name: nil, description: nil, user_id: user_id)
  end

  def self.logged
    where(game_id: nil).where.not(name: nil, description: nil)
  end

  private

  def roll
    update({
      category: ['anomaly', 'lifeform', 'species', 'planet', 'relic', 'derelict'].sample
    })
  end
end
