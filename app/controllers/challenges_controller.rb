class ChallengesController < ApplicationController
  def accept
    @game = Game.find(params[:game_id])
    @challenge = Challenge.find(params[:challenge_id])
    trait = @challenge.trait
    trait = trait.downcase.to_sym
    player_value = @game.stats[trait]
    challenge_value = @challenge.value

    if player_value > challenge_value
      @game.update(
        progress: @game.progress + 1,
        points: @game.points + challenge_value
      )
      @challenge.delete
      redirect_to game_path(id: @game.id)
    else
      # @todo Resource updates
    end
  end

  def retreat
    @game = Game.find(params[:game_id])
    @challenge = Challenge.find(params[:challenge_id])
    challenge_value = @challenge.value
    points = @game.points - challenge_value
    points = 0 if (points < 0)

    @game.update(points: points)
    @challenge.delete
    
    # @todo Resource updates

    redirect_to game_path(id: @game.id)
  end
end
