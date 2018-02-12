# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development? && User.find_by(email: 'user@example.com').nil?
  u = User.new(
    email: 'user@example.com',
    password: 'Example1',
    admin: true
  )
  u.save
end

if FlavorText.count == 0
  starting_flavor_text = [
    {
      body: 'Awaiting orders Captian.',
      category: 'default'
    },
    {
      body: "The ship is trapped in a gravitational eddy.",
      category: 'challenge',
      trait: 'sci',

      cmd_order: "Ride it out",
      cmd_success: "The eddy has subsided.",
      cmd_failed: "The eddy collapsed around the ship, we've taken damage.",
      sci_order: "Reverse Polarity",
      sci_success: "It worked! The eddy is neutralized.",
      sci_failed: "The eddy collapsed around the ship, we've taken damage.",
      med_order: "Release Anti-Grav Bio Organisim",
      med_success: "It worked! The organisim is effectively eating the eddy.",
      med_failed: "The eddy collapsed around the ship, we've taken damage.",
      tac_order: "Shoot our way out",
      tac_success: "We made it! We rode our own blast wave out of the eddy.",
      tac_failed: "The eddy collapsed around the ship, we've taken damage.",
      eng_order: "All power to engines",
      eng_success: "We've cleared the eddy!",
      eng_failed: "The eddy collapsed around the ship, we've taken damage.",
    },
    {
      body: "A mysterious virus is affecting nearly half the crew.",
      category: 'challenge',
      trait: 'med',

      cmd_order: "Ride it out",
      cmd_success: "The virus subsided on its own.",
      cmd_failed: "The virus eventually subsided, but several crew members perished.",
      sci_order: "Attempt laser extraction",
      sci_success: "The virus has neutralized.",
      sci_failed: "The treatment failed and killed several members of the crew. The virus eventually subsided.",
      med_order: "Develop a Counter Virus",
      med_success: "Success! The Counter Virus is killing the virus.",
      med_failed: "The counter virus failed. Crew members continued to die. The virus eventually subsided.",
      tac_order: "Quarantine the crew",
      tac_success: "The virus subsided on its own. The quarantine minimized spread.",
      tac_failed: "The virus eventually subsided, but the quarentine failed and several crew members perished.",
      eng_order: "Relase nanobots",
      eng_success: "It worked! The nanobots killed the virus.",
      eng_failed: "The virus eventually subsided, but several crew members perished."
    },
    {
      body: "Pirate raiders have ambused and surrounded the ship. They demand immediate surrender.",
      category: 'challenge',
      trait: 'tac',

      cmd_order: "Make contact",
      cmd_success: "We've convinced them to back down, they are retreating.",
      cmd_failed: "They refused to yield, we took damage from their attack, but then they vanished as suddenly as they appeared.",
      sci_order: "Hack their shields",
      sci_success: "It worked! With their shields down the raiders are in full retreat.",
      sci_failed: "The hack failed. We took damage from their attack, but then they vanished as suddenly as they appeared.",
      med_order: "Release Sleeping Gas",
      med_success: "Success! We've flooded their ventalation system with sleeping gas and made our escape.",
      med_failed: "No affect. We took damage from their attack, but then they vanished as suddenly as they appeared.",
      tac_order: "Open fire",
      tac_success: "Our attack was devasting, their remaining ships are in full retreat.",
      tac_failed: "We sustained heavy losses, but they eventually broke off.",
      eng_order: "All power to engines",
      eng_success: "Success! We lost them.",
      eng_failed: "We barely escaped, and took heavy damage while fleeing"
    },
    {
      body: "The ship is recieving a distress call from mining colony in the midst of a labor dispute",
      category: 'challenge',
      trait: 'cmd',

      cmd_order: "Make contact",
      cmd_success: "We've successfuly mediated their dispute.",
      cmd_failed: "We were unable to end their conflict and several crew members were injured when the matter escalated to violence.",
      sci_order: "Provide Technical Support",
      sci_success: "We were able to reduce workload and improve conditions on the mine through technical advancements. The conflict is resolved.",
      sci_failed: "Our innovations failed to appeal to the miners. Several crew members were injured when the matter escalated to violence.",
      med_order: "Provide Medical Aid",
      med_success: "The root of the conflict turned out to be a neuro virus affecting both sides. Our anitidote brought the situation back to normal.",
      med_failed: "Our aid was rejected. Several crew members were injured when the matter escalated to violence.",
      tac_order: "Occupy the colony",
      tac_success: "Our assult team quickly claimed all strategic assests in the colony and forced a truce between both sides.",
      tac_failed: "We secured an mutual surrender which ended the conflict, but many were killed in the fire fight, including members of our crew.",
      eng_order: "Assist operations",
      eng_success: "With the help of our engineers we were able to extract the remaining minerals and end the need for the colony. The owners and miners are going home richer, but at odds.",
      eng_failed: "Our aid was rejected. Several crew members were injured when the matter escalated to violence."
    },
    {
      body: "A fuel tank blew when we passed through an anomaly. If we don't contain the blast quickly we'll take permanent damage.",
      category: 'challenge',
      trait: 'eng',

      cmd_order: "Double shifts",
      cmd_success: "It took a lot of work, but the crew repaired damage and got the ship back in working order.",
      cmd_failed: "No amount of labor and determination could contain the fire. The ship has taken damage.",
      sci_order: "Containment field",
      sci_success: "The containment field held and the damage was minimal.",
      sci_failed: "The containment field failed and the damage was extensive.",
      med_order: "Release Inflamable Bio Foam",
      med_success: "Success! The foam neutralized the fire.",
      med_failed: "The form was unable to contain the fire. The ship has taken damage.",
      tac_order: "Jettison the Section",
      tac_success: "Jettisoning the affected area successfully minimized the damage.",
      tac_failed: "The jettison failed and the damage was extensive.",
      eng_order: "Emergency Repairs",
      eng_success: "An engineering crew quickly contained the blast and repaired the ship.",
      eng_failed: "An engineering crew contained the blast, but not before extensive damage was taken."
    },

    {
      body: "We've arrived.",
      category: 'engage'
    },
    {
      body: "We've made a discovery!",
      category: 'discovery'
    },
    {
      body: "We're out of fuel. We'll have to wait for our engines to recharge.",
      category: 'no_fuel'
    },
    {
      body: "We've left space dock. Where to Captian?",
      category: 'launch'
    },
    {
      body: "Probe deployed!",
      category: 'probe'
    },
    {
      body: "Scan initiated!",
      category: 'scan'
    },
    {
      body: "Repairs initiated!",
      category: 'repair'
    },
    {
      body: "Going to full alert status!",
      category: 'alert'
    },
    {
      body: "Enginees recharged Captian!",
      category: 'refueled'
    },
    {
      body: "We've found nothing",
      category: 'no_discovery'
    },
    {
      body: "Full power to the engines, we're falling back!",
      category: 'retreat'
    }
  ]

  starting_flavor_text.each do |ft|
    FlavorText.create(ft)
  end
end
