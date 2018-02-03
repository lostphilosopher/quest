class ChallengesController < ApplicationController
  before_action :authenticate_user!

  def accept
    @game = Game.find(params[:game_id])
    @challenge = Challenge.find(params[:challenge_id])

    tactic = params[:tactic].downcase.to_sym
    # Bonus for using recommended tactic
    if tactic == @challenge.trait_sym
      bonus = rand(1..100)
    else
      bonus = rand(0..1) # tie breaker
    end

    player_value = @game.stats[@challenge.trait_sym] + bonus
    challenge_value = @challenge.points

    logger.debug "P: #{player_value} C: #{challenge_value} L: #{@challenge.level} T: #{@challenge.trait} B: #{bonus}"

    if player_value > challenge_value
      @game.update(
        points: @game.points + challenge_value
      )
      @game.supply.expend_resource_and_fuel(tactic, true)
    else
      @game.update(
        points: @game.points - challenge_value/2
      )
      @game.supply.expend_resource_and_fuel(tactic, false)
    end

    @challenge.delete

    redirect_to game_path(id: @game.id)
  end

  def retreat
    @game = Game.find(params[:game_id])
    @challenge = Challenge.find(params[:challenge_id])
    challenge_value = @challenge.points
    points = @game.points - challenge_value
    progress = @game.progress - 2

    @game.update(
      points: points,
      progress: progress
    )
    @game.supply.expend_fuel(2)

    @challenge.delete

    redirect_to game_path(id: @game.id)
  end
end
