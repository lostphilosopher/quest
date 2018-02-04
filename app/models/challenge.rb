class Challenge < ApplicationRecord
  belongs_to :game
  after_create :roll

  def points
    (value * level) + settings.challenge_bump
  end

  def trait_sym
    trait.downcase.to_sym
  end

  private

  def roll
    yml = YAML.load_file('lib/yamls/scenarios.yml')
    yml = yml.to_a
    x = rand(0..yml.count - 1)
    scenario = yml[x]
    level = rand(1..7) # Not a setting
    # With 5 crew, 1 ship, and 1 station bonus the
    # "average" statistical player would have 350
    # for any given stat (min: 7 avg: ~350 max: 701).
    # The player should be able to win 50% of their
    # level 4 challenges, and the difficulty should
    # increase and decrease from there. A +150 "bump"
    # to challenge stats means a level 4 challenge is,
    # on average, 350 points - which aligns with the
    # average statistical player.
    update({
      level: level,
      value: rand(1..100),
      name: scenario.first,
      description: scenario.second,
      trait: [
        'CMD',
        'ENG',
        'MED',
        'SCI',
        'TAC'
      ].sample
    })
  end
end
