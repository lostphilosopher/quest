class PlayersController < ApplicationController
  before_action :authenticate_user!

  def update
    current_user.player.update(player_params)
    redirect_to games_path
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
