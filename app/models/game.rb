class Game < ApplicationRecord
  belongs_to :user
  has_many :officers, dependent: :destroy
  has_many :ships, dependent: :destroy
  has_many :challenges, dependent: :destroy
  has_many :discoveries
  has_one :supply, dependent: :destroy

  before_save :prevent_negatives

  def attribute_from_station(station)
    if station.is_a? String
      officer_at_station = self.officers.find_by(station: station.upcase)
      return 0 if officer_at_station.nil?
      officer_at_station.send(station.downcase.to_sym)
    elsif station.is_a? Symbol
      officer_at_station = self.officers.find_by(station: station.to_s.upcase)
      return 0 if officer_at_station.nil?
      officer_at_station.send(station.to_sym)
    end
  end

  def stats
    {
      # cmd: self.officers.sum(:cmd) + self.ships.sum(:cmd) + self.attribute_from_station(:cmd),
      cmd: self.officers.sum(:cmd) + self.ships.sum(:cmd),
      eng: self.officers.sum(:eng) + self.ships.sum(:eng),
      med: self.officers.sum(:med) + self.ships.sum(:med),
      tac: self.officers.sum(:tac) + self.ships.sum(:tac),
      sci: self.officers.sum(:sci) + self.ships.sum(:sci)
    }.freeze
  end

  private

  def prevent_negatives
    self.points = 0 if (self.points && self.points < 0)
    self.progress = 0 if (self.points && self.progress < 0)
  end
end
