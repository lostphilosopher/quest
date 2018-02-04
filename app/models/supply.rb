class Supply < ApplicationRecord
  belongs_to :game

  after_create :roll

  before_save :prevent_negatives

  def expend_resource_and_fuel(resource, success = false)
    expend_fuel(1)

    if success
      expend_resource(resource, 2, 1)
    else
      expend_resource(resource, 0, 2)
    end
  end

  def expend_fuel(amount = 1)
    update(fuel: self.fuel - amount)
  end

  def expend_resource(resource, add = 1, subtract = 1)
    case resource
    when :cmd
      update(
        cmd: self.cmd - subtract,
        eng: self.eng + add
      )
    when :eng
      update(
        eng: self.eng - subtract,
        sci: self.sci + add
      )
    when :sci
      update(
        sci: self.sci - subtract,
        med: self.med + add
      )
    when :med
      update(
        med: self.med - subtract,
        tac: self.tac + add
      )
    when :tac
      update(
        tac: self.tac - subtract,
        cmd: self.cmd + add
      )
    end
  end

  private

  def roll
    min = settings.supply_min
    max = settings.supply_max
    update({
      fuel: settings.max_fuel,
      shields: settings.max_shields,
      cmd: rand(min..max),
      eng: rand(min..max),
      med: rand(min..max),
      tac: rand(min..max),
      sci: rand(min..max)
    })
  end

  def prevent_negatives
    self.cmd = 0 if (self.cmd && self.cmd < 0)
    self.eng = 0 if (self.eng && self.eng < 0)
    self.med = 0 if (self.med && self.med < 0)
    self.tac = 0 if (self.tac && self.tac < 0)
    self.sci = 0 if (self.sci && self.sci < 0)
    self.fuel = 0 if (self.fuel && self.fuel < 0)
    self.shields = 0 if (self.shields && self.shields < 0)
  end
end
