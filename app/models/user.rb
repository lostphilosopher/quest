class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :game, dependent: :destroy
  has_one :player, dependent: :destroy

  after_create :roll_player

  private

  def roll_player
    p = Player.create(name: "#{Faker::Name.first_name} #{Faker::Ancient.hero}")
    update(
      player: p
    )
  end
end
