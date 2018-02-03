class ShipsController < ApplicationController
  before_action :authenticate_user!

  def update
    @ship = Ship.find(params[:id])

    @ship.update(ship_params)

    redirect_to edit_game_path(id: params[:game_id])
  end

  private

  def ship_params
    params.require(:ship).permit(:commanded)
  end
end
