class Game < ApplicationRecord
  has_many :officers
  has_many :challenges

  def stats
    {
      dip: self.officers.sum(:dip),
      cmd: self.officers.sum(:cmd),
      med: self.officers.sum(:med),
      tac: self.officers.sum(:tac),
      sci: self.officers.sum(:sci)
    }
  end
end
