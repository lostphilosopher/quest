class Officer < ApplicationRecord
  belongs_to :game

  after_create :roll

  private

  def roll
    update({
      name: "#{Faker::Name.first_name} #{Faker::Ancient.hero}",
      cmd: rand(1..100),
      dip: rand(1..100),
      med: rand(1..100),
      tac: rand(1..100),
      sci: rand(1..100)
    })
  end
end
