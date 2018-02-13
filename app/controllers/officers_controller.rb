class OfficersController < ApplicationController
  before_action :authenticate_user!

  def update
    @officer = Officer.find(params[:id])

    @officer.update(officer_params)

    redirect_to edit_game_path(id: params[:game_id])
  end

  def roll
    @game = Game.find_by(id: params[:game_id])
    return unless @game.points >= @settings.officer_cost
    @game.update(points: @game.points - @settings.officer_cost)
    Officer.create(game_id: @game.id)
    redirect_to edit_game_path(id: params[:game_id])
  end

  private

  def officer_params
    params.require(:officer).permit(:station)
  end
end
