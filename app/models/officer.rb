class Officer < ApplicationRecord
  belongs_to :game

  after_create :roll

  def attribute_from_station
    game.stats[self.station.downcase.to_sym]
  end

  def station_long_form
    s = self.station
    case s
    when 'CMD'
      'First Officer'
    when 'ENG'
      'Chief Engineer'
    when 'MED'
      'Chief Doctor'
    when 'TAC'
      'Chief Tactical Officer'
    when 'SCI'
      'Chief Scientist'
    end
  end

  private

  def roll
    update({
      name: "#{Faker::Name.first_name} #{Faker::Ancient.hero}",
      cmd: rand(1..100),
      eng: rand(1..100),
      med: rand(1..100),
      tac: rand(1..100),
      sci: rand(1..100)
    })
  end
end
