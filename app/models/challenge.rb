class Challenge < ApplicationRecord
  belongs_to :game
  after_create :roll

  private

  def roll
    yml = YAML.load_file('lib/yamls/scenarios.yml')
    yml = yml.to_a
    x = rand(0..yml.count - 1)
    scenario = yml[x]
    level = rand(1..5)
    update({
      level: level,
      value: rand(1..100) * level,
      name: scenario.first,
      description: scenario.second,
      trait: [
        'DIP',
        'CMD',
        'MED',
        'SCI',
        'TAC' 
      ].sample
    })
  end
end
