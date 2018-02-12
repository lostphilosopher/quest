class FlavorText < ApplicationRecord
  # DO NOT CHANGE KEY/VALUE PAIRS!!!
  enum category: {
    default: 0,
    challenge: 1,
    engage: 2,
    discovery: 3,
    no_fuel: 4,
    launch: 5,
    probe: 6,
    scan: 7,
    repair: 8,
    alert: 9,
    refueled: 10,
    no_discovery: 11,
    retreat: 12
  }
  enum trait: {
    not_applicable: 0,
    cmd: 1,
    sci: 2,
    med: 3,
    tac: 4,
    eng: 5
  }
end
