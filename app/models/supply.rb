class Supply < ApplicationRecord
  belongs_to :game

  after_create :roll

  before_save :prevent_negatives
  before_save :prevent_excesses

  def expend_resource_and_fuel(resource, success = false)
    expend_fuel(1)

    if success
      expend_resource(resource, 1, 1)
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

  def repair(value)
    return if shields >= settings.max_shields

    repaired_value = shields + value

    repaired_value = settings.max_shields if (repaired_value > settings.max_shields)
    update(
      last_eng_at: Time.zone.now,
      shields: repaired_value
    )
  end

  def in_alert?
    last_tac_at && (Time.zone.now < (last_tac_at + 3.minutes))
  end

  def can_tac?
    return true unless last_tac_at
    Time.zone.now > tac_refresh
  end

  def tac_refresh
    last_tac_at + settings.tac_cycle_time.hours
  end

  def can_eng?
    return true unless last_eng_at
    Time.zone.now > eng_refresh
  end

  def eng_refresh
    last_eng_at + settings.eng_cycle_time.hours
  end

  def can_sci?
    return true unless last_sci_at
    Time.zone.now > sci_refresh
  end

  def sci_refresh
    last_sci_at + settings.sci_cycle_time.hours
  end

  def can_med?
    return true unless last_med_at
    Time.zone.now > med_refresh
  end

  def med_refresh
    last_med_at + settings.med_cycle_time.hours
  end

  def reup
    max = settings.supply_max
    update({
      fuel: settings.max_fuel,
      shields: settings.max_shields,
      cmd: max,
      eng: max,
      med: max,
      tac: max,
      sci: max
    })
  end

  private

  def roll
    max = settings.supply_max
    update({
      fuel: settings.max_fuel,
      shields: settings.max_shields,
      cmd: max,
      eng: max,
      med: max,
      tac: max,
      sci: max
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

  def prevent_excesses
    max = settings.supply_max

    self.cmd = max if (self.cmd && self.cmd > max)
    self.eng = max if (self.eng && self.eng > max)
    self.med = max if (self.med && self.med > max)
    self.tac = max if (self.tac && self.tac > max)
    self.sci = max if (self.sci && self.sci > max)
    self.fuel = max if (self.fuel && self.fuel > settings.max_fuel)
    self.shields = max if (self.shields && self.shields > settings.max_shields)
  end
end
