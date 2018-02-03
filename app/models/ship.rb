class Ship < ApplicationRecord
  belongs_to :game

  after_create :roll

  private

  def roll
    update({
      name: "#{Faker::Ancient.titan}",
      cmd: rand(1..100),
      eng: rand(1..100),
      med: rand(1..100),
      tac: rand(1..100),
      sci: rand(1..100)
    })
  end
end
