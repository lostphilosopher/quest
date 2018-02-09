class ChallengesController < ApplicationController
  before_action :authenticate_user!

  def accept
    @game = Game.find(params[:game_id])
    @challenge = Challenge.find(params[:challenge_id])

    tactic = params[:tactic].downcase.to_sym
    # Bonus for using recommended tactic
    if tactic == @challenge.trait_sym
      bonus = @game.attribute_from_station(@challenge.trait_sym)
    else
      bonus = rand(0..1) # tie breaker
    end

    if @game.supply.in_alert?
      crit_bonus = bonus * 2
    else
      crit_bonus = 0
    end

    player_value = @game.stats[@challenge.trait_sym] + bonus + crit_bonus
    challenge_value = @challenge.points

    logger.debug "[ChallengeReadout] P: #{player_value} C: #{challenge_value} L: #{@challenge.level} T: #{@challenge.trait} B: #{bonus} CB: #{crit_bonus}"

    Message.create(
      source: current_user.player.name,
      body: "#{tactic.capitalize}",
      game_id: @game.id
    )

    if player_value > challenge_value
      Message.create(
        source: @game.officers.sample.name,
        body: "Tactic successful. All clear.",
        game_id: @game.id
      )
      @game.update(
        progress: @game.progress + 1,
        points: @game.points + challenge_value
      )
      @game.supply.expend_resource_and_fuel(tactic, true)
    else
      Message.create(
        source: @game.officers.sample.name,
        body: "We're taking damage!",
        game_id: @game.id
      )
      @game.update(
        points: @game.points - challenge_value/@settings.failure_point_divisor
      )
      @game.supply.expend_resource_and_fuel(tactic, false)
      @game.supply.update(shields: @game.supply.shields - @challenge.level)
    end

    @challenge.delete

    redirect_to game_path(id: @game.id)
  end

  def retreat
    @game = Game.find(params[:game_id])
    @challenge = Challenge.find(params[:challenge_id])
    challenge_value = @challenge.points
    points = @game.points - challenge_value/@settings.retreat_points_divisor
    progress = @game.progress - @settings.retreat_progress_cost

    @game.update(
      points: points,
      progress: progress
    )
    @game.supply.expend_fuel(@settings.retreat_fuel_cost)

    @challenge.delete
    Message.create(
      source: @game.officers.sample.name,
      body: "Full power to the engines, we're falling back!",
      game_id: @game.id
    )
    redirect_to game_path(id: @game.id)
  end
end
