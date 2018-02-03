class Region < ApplicationRecord

  after_create :roll

  private

  def roll
    update({
      name: "#{Faker::Ancient.primordial}"
    })
  end
end
