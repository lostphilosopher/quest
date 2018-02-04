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

    player_value = @game.stats[@challenge.trait_sym] + bonus
    challenge_value = @challenge.points

    logger.debug "[ChallengeReadout] P: #{player_value} C: #{challenge_value} L: #{@challenge.level} T: #{@challenge.trait} B: #{bonus}"

    if player_value > challenge_value
      flash[:game] = "Tactic successful. All clear."
      @game.update(
        progress: @game.progress + 1,
        points: @game.points + challenge_value
      )
      @game.supply.expend_resource_and_fuel(tactic, true)
    else
      flash[:game] = "We're taking damage!"
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

    flash[:game] = "Full power to the engines, we're falling back!"
    redirect_to game_path(id: @game.id)
  end
end
