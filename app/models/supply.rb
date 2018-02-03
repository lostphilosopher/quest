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
    update({
      fuel: 100,
      cmd: rand(15..25),
      eng: rand(15..25),
      med: rand(15..25),
      tac: rand(15..25),
      sci: rand(15..25)
    })
  end

  def prevent_negatives
    self.cmd = 0 if (self.cmd && self.cmd < 0)
    self.eng = 0 if (self.eng && self.eng < 0)
    self.med = 0 if (self.med && self.med < 0)
    self.tac = 0 if (self.tac && self.tac < 0)
    self.sci = 0 if (self.sci && self.sci < 0)
  end
end
