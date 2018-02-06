class DiscoveriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @game = current_user.game
    @unclaimed_discoveries = @game.discoveries.where(logged: nil) if @game
    @discoveries = Discovery.where(logged: true)
  end

  def update
    @game = current_user.game
    @discovery = Discovery.find_by(id: params[:id])

    if discovery_params[:name].nil? || discovery_params[:description].nil?
      # @todo Flash
      redirect_to edit_discovery_path(id: @discovery.id)
    end

    @discovery.update(discovery_params)
    @discovery.update(
      ship_name: current_user.game.ships.first.name,
      captain_name: current_user.player.name,
      player_id: current_user.player.id,
      user_id: current_user.id,
      logged: true
    )

    redirect_to discoveries_path
  end

  private

  def discovery_params
    params.require(:discovery).permit(
      :name,
      :description,
      :type,
      :importance,
      :user_id,
      :ship_name
    )
  end
end
