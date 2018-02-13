class Officer < ApplicationRecord
  belongs_to :game

  after_create :roll

  def options
    array = []
    array << ['Not Enlisted', nil]
    array << ['First Officer (CMD)', 'CMD'] if game.officers.where(station: 'CMD').empty?
    array << ['Chief Engineer (ENG)', 'ENG'] if game.officers.where(station: 'ENG').empty?
    array << ['Chief Doctor (MED)', 'MED'] if game.officers.where(station: 'MED').empty?
    array << ['Tactical Officer (TAC)', 'TAC'] if game.officers.where(station: 'TAC').empty?
    array << ['Chief Scientist (SCI)', 'SCI'] if game.officers.where(station: 'SCI').empty?
    array
  end

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

  def level
    (cmd + eng + med + tac + sci)/100
  end

  def self.assigned
    self.where.not(station: '')
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
